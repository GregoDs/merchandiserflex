import 'package:flexmerchandiser/features/customers/ui/customer_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexmerchandiser/features/customers/cubit/customers_cubit.dart';
import 'package:flexmerchandiser/features/customers/cubit/customers_state.dart';
import 'package:flexmerchandiser/features/customers/models/customers_model.dart';
import 'package:flexmerchandiser/widgets/custom_snackbar.dart';
import 'package:flexmerchandiser/features/customers/ui/customer_shimmer.dart';
import 'package:flexmerchandiser/utils/cache/shared_preferences_helper.dart';
import 'package:flexmerchandiser/features/auth/models/user_model.dart';

class CustomerDetailsPage extends StatefulWidget {
  final String outletId;
  const CustomerDetailsPage({super.key, required this.outletId});

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _jumpToPage(1);
  }

  void _jumpToPage(int page) {
    context.read<CustomersCubit>().fetchCustomers(
      outletId: widget.outletId,
      page: page,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<CustomersCubit, CustomersState>(
      listener: (context, state) {
        if (state is CustomersError) {
          CustomSnackBar.showError(
            context,
            title: "Error",
            message: state.message,
          );
        }
      },
      child: Scaffold(
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
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
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
                        icon: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Check out your Outlet details here",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search by name, phone, flexsave (yes/no), followup",
                      hintStyle: GoogleFonts.montserrat(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: BlocBuilder<CustomersCubit, CustomersState>(
                        builder: (context, state) {
                          if (state is CustomersLoading) {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              ),
                            );
                          }
                          return IconButton(
                            icon: Icon(Icons.send, color: Colors.white),
                            onPressed: _onSearchPressed,
                          );
                        },
                      ),
                    ),
                    onSubmitted: (_) {
                      // Optionally trigger search on keyboard submit
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPaginationBar(context),
                  const SizedBox(height: 8),
                  Expanded(child: _buildCustomerList(screenWidth)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationBar(BuildContext context) {
    return BlocBuilder<CustomersCubit, CustomersState>(
      builder: (context, state) {
        int currentPage = 1;
        int totalPages = 1;
        if (state is CustomersSuccess) {
          currentPage = state.currentPage;
          totalPages = state.totalPages;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Page $currentPage of $totalPages",
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 60,
              child: TextField(
                controller: _pageController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.montserrat(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Page",
                  hintStyle: GoogleFonts.montserrat(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 8,
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final page = int.tryParse(_pageController.text);
                if (page != null && page > 0 && page <= totalPages) {
                  _jumpToPage(page);
                }
              },
              child: Text("Go", style: GoogleFonts.montserrat()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomerList(double screenWidth) {
    return BlocBuilder<CustomersCubit, CustomersState>(
      builder: (context, state) {
        if (state is CustomersLoading || state is CustomersError) {
          // Show shimmer on loading or error
          return ShimmerCustomerRow(screenWidth: screenWidth);
        } else if (state is CustomersSuccess) {
          var customers = state.customers;
          if (_searchQuery.isNotEmpty) {
            customers =
                customers.where((c) {
                  final name = c.name.toLowerCase();
                  final followup = (c.followup?.status ?? '').toLowerCase();
                  String displayPhone =
                      c.phone.startsWith('254')
                          ? c.phone.replaceFirst('254', '80')
                          : c.phone;
                  // If search is numeric, match phone number from the start (display format)
                  if (RegExp(r'^[0-9]+$').hasMatch(_searchQuery)) {
                    return displayPhone.startsWith(_searchQuery);
                  }
                  // Otherwise, match name or followup status
                  return name.contains(_searchQuery) ||
                      followup.contains(_searchQuery);
                }).toList();
          }
          if (customers.isEmpty) {
            return Center(
              child: Text(
                "No customers found.",
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
            );
          }
          return ListView.separated(
            itemCount: customers.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final customer = customers[index];
              return _buildCustomerCard(customer);
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildCustomerCard(Customer customer) {
    String displayPhone =
        customer.phone.startsWith('254')
            ? customer.phone.replaceFirst('254', '80')
            : customer.phone;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerProfilePage(customer: customer),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Row(
                    children: [
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
                    ],
                  ),
                  Text(
                    customer.dateCreated,
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  customer.followup?.status ?? "N/A",
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    // Optionally, copy or call the number
                  },
                  child: Text(
                    displayPhone,
                    style: GoogleFonts.montserrat(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchPressed() async {
    final query = _searchController.text.trim();
    String? customerName;
    String? phone;
    String? isFlexsaveCustomer;
    String? customerFollowup;

    if (query.toLowerCase() == 'yes' || query.toLowerCase() == 'no') {
      isFlexsaveCustomer = query;
    } else if (RegExp(r'^(07\d{8}|2547\d{8})$').hasMatch(query)) {
      phone = query;
    } else if (query.toLowerCase().startsWith('followup:')) {
      customerFollowup = query.split(':').last.trim();
    } else {
      customerName = query;
    }

    final userData = await SharedPreferencesHelper.getUserData();
    final userId = UserModel.fromJson(userData!).user.id.toString();

    context.read<CustomersCubit>().searchCustomers(
      userId: userId,
      outletId: widget.outletId,
      customerName: customerName,
      phone: phone,
      isFlexsaveCustomer: isFlexsaveCustomer,
      customerFollowup: customerFollowup,
    );
  }
}
