import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexmerchandiser/features/customers/models/customers_model.dart';
import 'package:flexmerchandiser/features/customers/repo/customers_repo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flexmerchandiser/widgets/custom_snackbar.dart';
import 'package:flexmerchandiser/features/chama/ui/register_chama.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexmerchandiser/features/chama/cubit/chama_cubit.dart';
import 'package:flexmerchandiser/features/chama/repo/chama_repo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomerProfilePage extends StatefulWidget {
  final Customer customer;

  const CustomerProfilePage({super.key, required this.customer});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  String? _selectedStatus;
  TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;
  bool isUpdatingStatus = false;
  bool _didUpdate = false;
  PaymentSummary? paymentSummary;
  final CustomerRepo _customerRepo = CustomerRepo();
  Customer? _updatedCustomer;

  List<String> statusOptions = [
    "NOT CALLED",
    "NOT ANSWERED",
    "ANSWERED",
    "CALL BACK LATER",
    "RESTRICTED",
    "UNREACHABLE",
    "NOT EXIST",
    "BUSY",
    "NOT IN SERVICE",
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = _mapApiStatusToDropdown(widget.customer.followup?.status);
    _descriptionController.text = widget.customer.followup?.description ?? '';
    _fetchPaymentSummary();
  }

  Future<void> _fetchPaymentSummary() async {
    setState(() {
      isLoading = true;
    });

    try {
      final summary = await _customerRepo.fetchPaymentSummary(
        widget.customer.phone,
      );
      if (summary != null) {
        setState(() {
          paymentSummary = summary;
        });
      }
    } catch (e) {
      print('❌ Error fetching payment summary: $e');
      // Don't show error to user for payment summary as it's not critical
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateFollowUpStatus() async {
    if (_selectedStatus == null) return;

    setState(() {
      isUpdatingStatus = true;
    });

    try {
      final response = await _customerRepo.updateFollowUpStatus(
        userId: widget.customer.id.toString(),
        status: _selectedStatus!,
        description:
            _selectedStatus == 'ANSWERED' ? _descriptionController.text : null,
      );

      // Create updated customer object with new followup status
      final updatedFollowup = CustomerFollowup(
        id: widget.customer.followup?.id ?? 0,
        userId: widget.customer.id,
        status: _mapDropdownToApiStatus(_selectedStatus!),
        createdBy: widget.customer.followup?.createdBy ?? 0,
        description:
            _selectedStatus == 'ANSWERED' ? _descriptionController.text : null,
        date: DateTime.now(),
        createdAt: widget.customer.followup?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updatedCustomer = Customer(
        id: widget.customer.id,
        name: widget.customer.name,
        phone: widget.customer.phone,
        isFlexsaveCustomer: widget.customer.isFlexsaveCustomer,
        followup: updatedFollowup,
        dateCreated: widget.customer.dateCreated,
      );

      setState(() {
        _updatedCustomer = updatedCustomer;
        _didUpdate = true;
      });

      CustomSnackBar.showSuccess(
        context,
        title: 'Success',
        message: 'Status updated successfully',
      );
      // Pop and return true to trigger refresh in the previous page
      // Navigator.of(context).pop(true);
    } catch (e) {
      print('❌ Error updating status: $e');
      CustomSnackBar.showError(
        context,
        title: 'Error',
        message: 'Failed to update status',
      );
    } finally {
      setState(() {
        isUpdatingStatus = false;
      });
    }
  }

  String _mapDropdownToApiStatus(String dropdownStatus) {
    switch (dropdownStatus) {
      case 'ANSWERED':
        return 'CONTACTED';
      case 'NOT CALLED':
        return 'NOT_CONTACTED';
      case 'BUSY':
        return 'BUSY';
      case 'NOT ANSWERED':
        return 'NOT_ANSWERED';
      case 'CALL BACK LATER':
        return 'CALL_BACK_LATER';
      case 'RESTRICTED':
        return 'RESTRICTED';
      case 'UNREACHABLE':
        return 'UNREACHABLE';
      case 'NOT EXIST':
        return 'NOT_EXIST';
      case 'NOT IN SERVICE':
        return 'NOT_IN_SERVICE';
      default:
        return dropdownStatus; // Return the actual status if no mapping found
    }
  }

  String? _mapApiStatusToDropdown(String? apiStatus) {
    if (apiStatus == null) return "NOT CALLED";

    // Map API status to dropdown options
    switch (apiStatus.toUpperCase()) {
      case 'CONTACTED':
        return 'ANSWERED';
      case 'NOT_CONTACTED':
        return 'NOT CALLED';
      case 'BUSY':
        return 'BUSY';
      case 'NOT_ANSWERED':
        return 'NOT ANSWERED';
      case 'CALL_BACK_LATER':
        return 'CALL BACK LATER';
      case 'RESTRICTED':
        return 'RESTRICTED';
      case 'UNREACHABLE':
        return 'UNREACHABLE';
      case 'NOT_EXIST':
        return 'NOT EXIST';
      case 'NOT_IN_SERVICE':
        return 'NOT IN SERVICE';
      default:
        return apiStatus; // Return the actual status if no mapping found
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      // Replace +254 or 254 at the start with 80
      String formattedNumber = phoneNumber;
      if (phoneNumber.startsWith('+254')) {
        formattedNumber = '80${phoneNumber.substring(4)}';
      } else if (phoneNumber.startsWith('254')) {
        formattedNumber = '80${phoneNumber.substring(3)}';
      } else if (phoneNumber.startsWith('0')) {
        formattedNumber = '80${phoneNumber.substring(1)}';
      }

      final Uri url = Uri(scheme: 'tel', path: formattedNumber);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar( 
          SnackBar(
            content: Text(
              'Could not launch dialer with number $formattedNumber',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error launching dialer: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final customer = _updatedCustomer ?? widget.customer;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/appbarbackground.png",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 56),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(_didUpdate),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Flexpay",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications_none, color: Colors.white),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Customer Details",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.amber,
                                        width: 3,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 32,
                                      backgroundImage: AssetImage(
                                        'assets/images/profile_placeholder.png',
                                      ), // or NetworkImage
                                    ),
                                  ),
                                  SizedBox(width: 140),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          customer.name,
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18, // smaller font
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade900,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade800,
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Last activity:",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12,
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                              Text(
                                                customer
                                                    .dateCreated, // Replace with actual value
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      if (customer.phone != null &&
                                          customer.phone!.isNotEmpty) {
                                        _makePhoneCall(customer.phone!);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'No valid phone number available',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      customer.phone?.replaceFirst(
                                            '254',
                                            '80',
                                          ) ??
                                          'N/A',
                                      style: GoogleFonts.montserrat(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                            0.04,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  //                       GestureDetector(
                                  //   onTap: () => (customer["phone"]),
                                  //   child: Text(
                                  //     customer["phone"]?.toString().replaceFirst("254", "80") ??
                                  //         "N/A",
                                  //     style: GoogleFonts.montserrat(
                                  //       fontSize: screenWidth * 0.04,
                                  //       color: Colors.blue,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    "Flexsave Customer: ",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    customer.isFlexsaveCustomer ? "Yes" : "No",
                                    style: GoogleFonts.montserrat(
                                      color:
                                          customer.isFlexsaveCustomer
                                              ? Colors.green
                                              : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (!customer.isFlexsaveCustomer) ...[
                                    SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => BlocProvider(
                                                  create:
                                                      (context) => ChamaCubit(
                                                        chamaRepo: ChamaRepo(),
                                                      ),
                                                  child: RegisterChamaPage(
                                                    phoneNumber: customer.phone,
                                                    agentId:
                                                        6884, // Replace with actual agent ID
                                                  ),
                                                ),
                                          ),
                                        );
                                        if (result == true) {
                                          // Refresh the customer data or update the UI
                                          setState(() {
                                            _updatedCustomer = Customer(
                                              id: customer.id,
                                              name: customer.name,
                                              phone: customer.phone,
                                              isFlexsaveCustomer:
                                                  true, // Update this
                                              followup: customer.followup,
                                              dateCreated: customer.dateCreated,
                                            );
                                          });
                                        }
                                      },
                                      child: Text(
                                        "Register",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Status Update Section
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Follow-up Status",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                value: _selectedStatus,
                                dropdownColor: Colors.grey.shade800,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                items:
                                    statusOptions.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedStatus = newValue;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              if (_selectedStatus == 'ANSWERED')
                                TextField(
                                  controller: _descriptionController,
                                  maxLines: 3,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Enter description...",
                                    hintStyle: GoogleFonts.montserrat(
                                      color: Colors.white70,
                                    ),
                                    filled: true,
                                    fillColor: Colors.black.withOpacity(0.5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed:
                                    isUpdatingStatus
                                        ? null
                                        : _updateFollowUpStatus,
                                child:
                                    isUpdatingStatus
                                        ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                        : Text(
                                          "Update Status",
                                          style: GoogleFonts.montserrat(),
                                        ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Payment Summary Section with Shimmer
                        _buildPaymentSummary(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWave(
              itemBuilder: (BuildContext context, int index) {
                return const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Loading Payment Summary.....',
              style: GoogleFonts.montserrat(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (paymentSummary == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          "No payment summary available",
          style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment Summary",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _buildPaymentInfoRow(
            "Customer Category:",
            paymentSummary!.customerCategory,
          ),
          _buildPaymentInfoRow(
            "Payment Pattern:",
            paymentSummary!.paymentPattern,
          ),
          _buildPaymentInfoRow(
            "Average Payment:",
            paymentSummary!.averagePayment,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 16),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

