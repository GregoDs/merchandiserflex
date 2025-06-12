import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flexmerchandiser/features/chama/cubit/chama_products_cubit.dart';
import 'package:flexmerchandiser/features/chama/cubit/chama_products_state.dart';
import 'package:flexmerchandiser/features/chama/repo/chama_repo.dart';
import 'package:flexmerchandiser/widgets/custom_snackbar.dart';
import 'package:flexmerchandiser/features/chama/cubit/chama_subscription_cubit.dart';
import 'package:flexmerchandiser/features/chama/ui/chama_products_page.dart';

class ChamaTypePage extends StatefulWidget {
  final String phoneNumber;
  const ChamaTypePage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<ChamaTypePage> createState() => _ChamaTypePageState();
}

class _ChamaTypePageState extends State<ChamaTypePage> {
  String? selectedType;
  bool isLoading = false; // This will be managed by the cubit now

  @override
  void initState() {
    super.initState();
    // Optionally fetch initial data or set a default selected type
  }

  void _selectType(String type) {
    setState(() {
      selectedType = type;
    });
  }

  void _fetchChamaProducts() {
    if (selectedType != null) {
      context.read<ChamaProductsCubit>().fetchProducts(selectedType!);
    } else {
      CustomSnackBar.showWarning(
        context,
        title: 'Warning',
        message: 'Please select a chama type.',
      );
    }
  }

  Widget _buildSelectableIcon(
    IconData icon,
    String label,
    String type,
    bool isDarkMode,
  ) {
    bool isSelected = selectedType == type;

    return GestureDetector(
      onTap: () => _selectType(type),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isSelected
                      ? Colors.blue
                      : (isDarkMode ? Colors.grey[800] : Colors.white),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.orange,
                width: 3,
              ),
            ),
            child: Icon(
              icon,
              color:
                  isSelected
                      ? Colors.white
                      : (isDarkMode ? Colors.white70 : Color(0xFF337687)),
              size: 30,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color:
                  isSelected
                      ? Colors.blue
                      : (isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Chamas",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textColor),
            onPressed: () {
              Navigator.popUntil(
                context,
                (route) => route.settings.name == '/customer-details',
              );
            },
          ),
        ),
        body: BlocConsumer<ChamaProductsCubit, ChamaProductsState>(
          listener: (context, state) {
            if (state is ChamaProductsSuccess) {
              CustomSnackBar.showSuccess(
                context,
                title: 'Success',
                message: 'Chama products fetched successfully!',
              );
              // Navigate to the next page with products
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider(
                        create:
                            (context) =>
                                ChamaSubscriptionCubit(chamaRepo: ChamaRepo()),
                        child: ChamaProductsPage(
                          products: state.products,
                          phoneNumber: widget.phoneNumber,
                        ),
                      ),
                ),
              );
            } else if (state is ChamaProductsError) {
              CustomSnackBar.showError(
                context,
                title: 'Error',
                message: state.message,
              );
            }
          },
          builder: (context, state) {
            isLoading = state is ChamaProductsLoading;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                children: [
                  Lottie.asset(
                    "assets/images/chamatype.json",
                    height: MediaQuery.of(context).size.height * 0.25,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Welcome to Chamas",
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Start saving towards your goals with our wide range of products.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  Text(
                    "Choose your product.",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSelectableIcon(
                        Icons.calendar_month,
                        "Half-Yearly",
                        "half_yearly",
                        isDarkMode,
                      ),
                      SizedBox(width: 30),
                      _buildSelectableIcon(
                        Icons.group,
                        "Yearly",
                        "yearly",
                        isDarkMode,
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: isLoading ? null : _fetchChamaProducts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF337687),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child:
                        isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              "Proceed with Chama",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ],
              ),
            );
          },
        ),
        // bottomNavigationBar: NavigationBarWidget(), // Assuming this is not needed here
      ),
    );
  }
}
