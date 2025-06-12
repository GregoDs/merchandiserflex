import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexmerchandiser/features/chama/models/chama_type_model.dart'; // For ChamaProduct model
import 'package:flexmerchandiser/features/chama/cubit/chama_subscription_cubit.dart';
import 'package:flexmerchandiser/features/chama/cubit/chama_subscription_state.dart';
import 'package:flexmerchandiser/features/chama/repo/chama_repo.dart'; // Needed for BlocProvider
import 'package:flexmerchandiser/widgets/custom_snackbar.dart';

class ChamaProductsPage extends StatefulWidget {
  final List<ChamaProduct> products;
  final String phoneNumber;

  const ChamaProductsPage({
    Key? key,
    required this.products,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<ChamaProductsPage> createState() => _ChamaProductsPageState();
}

class _ChamaProductsPageState extends State<ChamaProductsPage> {
  int? _selectedProductId;
  final TextEditingController _depositAmountController =
      TextEditingController();

  @override
  void dispose() {
    _depositAmountController.dispose();
    super.dispose();
  }

  void _selectProduct(int productId) {
    setState(() {
      _selectedProductId = productId;
    });
  }

  void _showDepositDialog(int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Get system brightness for theme adjustments
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDarkMode ? Colors.white : Colors.black;
        final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
        final hintTextColor =
            isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
        final fieldFillColor =
            isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200;

        return AlertDialog(
          backgroundColor:
              cardColor, // Darker background for dialog in dark mode
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Enter Deposit Amount',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          content: TextField(
            controller: _depositAmountController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.montserrat(color: textColor),
            decoration: InputDecoration(
              hintText: "Enter amount",
              hintStyle: GoogleFonts.montserrat(color: hintTextColor),
              filled: true,
              fillColor: fieldFillColor, // Different fill color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                  color: Colors.redAccent,
                ), // Styled text
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Styled button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                final depositAmount = double.tryParse(
                  _depositAmountController.text,
                );
                if (depositAmount != null) {
                  Navigator.of(context).pop();
                  _subscribeToChama(productId, depositAmount);
                } else {
                  CustomSnackBar.showError(
                    context,
                    title: 'Invalid Amount',
                    message: 'Please enter a valid number.',
                  );
                }
              },
              child: Text(
                'Subscribe',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                ), // Styled text
              ),
            ),
          ],
        );
      },
    );
  }

  void _subscribeToChama(int productId, double depositAmount) {
    context.read<ChamaSubscriptionCubit>().subscribeToChama(
      phoneNumber: widget.phoneNumber,
      productId: productId,
      depositAmount: depositAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Chama Products",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: BlocListener<ChamaSubscriptionCubit, ChamaSubscriptionState>(
        listener: (context, state) {
          if (state is ChamaSubscriptionSuccess) {
            CustomSnackBar.showSuccess(
              context,
              title: 'Success',
              message: 'Successfully subscribed to chama!',
            );
            // Navigate back to the CustomerProfilePage
            Navigator.popUntil(
              context,
              (route) => route.settings.name == '/customer-profile',
            ); // Assuming customer profile route name is /customerProfile
          } else if (state is ChamaSubscriptionError) {
            CustomSnackBar.showError(
              context,
              title: 'Error',
              message: state.message,
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Available Products",
                style: GoogleFonts.montserrat(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  final bool isSelected = _selectedProductId == product.id;
                  return GestureDetector(
                    onTap: () => _selectProduct(product.id),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? Colors.orange : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: GoogleFonts.montserrat(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Monthly Price: \Kshs ${product.monthlyPrice}',
                            style: GoogleFonts.montserrat(
                              fontSize: screenWidth * 0.04,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Target Amount: \Kshs ${product.targetAmount}',
                            style: GoogleFonts.montserrat(
                              fontSize: screenWidth * 0.04,
                              color: Colors.black87,
                            ),
                          ),
                          if (isSelected) ...[
                            SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () => _showDepositDialog(product.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  'Join Chama',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
