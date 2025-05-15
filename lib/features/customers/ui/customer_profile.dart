import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexmerchandiser/features/customers/models/customers_model.dart';

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
  PaymentSummary? paymentSummary;

  final List<String> statusOptions = [
    'Not Contacted',
    'Contacted',
    'Interested',
    'Not Interested',
    'Follow-up',
    'Converted',
    'ANSWERED', // Add all possible API values here
    // ...add more if needed
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = _mapApiStatusToDropdown(widget.customer.followup?.status);
    _descriptionController.text = widget.customer.followup?.description ?? '';
  }

  String? _mapApiStatusToDropdown(String? apiStatus) {
    switch (apiStatus) {
      case 'ANSWERED':
        return 'Contacted';
      // Add more mappings as needed
      default:
        return apiStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () => Navigator.of(context).maybePop(),
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
                        // Customer Info Section
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
                                          widget.customer.name,
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
                                                widget
                                                    .customer
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
                                  Text(
                                    widget.customer.phone.startsWith('254')
                                        ? widget.customer.phone.replaceFirst(
                                          '254',
                                          '80',
                                        )
                                        : widget.customer.phone,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.blueAccent,
                                      fontSize: 16,
                                    ),
                                  ),
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
                                    widget.customer.isFlexsaveCustomer
                                        ? "Yes"
                                        : "No",
                                    style: GoogleFonts.montserrat(
                                      color:
                                          widget.customer.isFlexsaveCustomer
                                              ? Colors.green
                                              : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
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
                                onPressed: () {
                                  // Implement status update logic here
                                  // You would typically call an API endpoint to update the status
                                },
                                child: Text(
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

                        // Payment Summary Section (Dummy Data)
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
      return Center(child: CircularProgressIndicator());
    }
    if (paymentSummary == null) {
      return Text(
        "No payment summary found.",
        style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
      );
    }
    return Container(
      padding: EdgeInsets.all(16),
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
          SizedBox(height: 12),
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
