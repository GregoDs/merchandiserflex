import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexmerchandiser/features/chama/cubit/chama_cubit.dart';
import 'package:flexmerchandiser/features/chama/cubit/chama_state.dart';
import 'package:flexmerchandiser/features/chama/repo/chama_repo.dart';
import 'package:flexmerchandiser/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:flexmerchandiser/features/chama/cubit/chama_products_cubit.dart';
import 'package:flexmerchandiser/features/chama/ui/chama_type_page.dart';

class RegisterChamaPage extends StatefulWidget {
  final String phoneNumber;
  final int agentId;

  const RegisterChamaPage({
    Key? key,
    required this.phoneNumber,
    required this.agentId,
  }) : super(key: key);

  @override
  State<RegisterChamaPage> createState() => _RegisterChamaPageState();
}

class _RegisterChamaPageState extends State<RegisterChamaPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  String? _selectedGender;
  int? _selectedDay;
  int? _selectedMonth;
  int? _selectedYear;

  bool _isLoading = false;

  final List<String> _genderOptions = ['Male', 'Female'];
  final List<int> _days = List<int>.generate(31, (i) => i + 1);
  final List<int> _months = List<int>.generate(12, (i) => i + 1);
  final List<int> _years = List<int>.generate(
    DateTime.now().year - 1900 + 1,
    (i) => 1900 + i,
  );

  @override
  void initState() {
    super.initState();
    _phoneNumberController.text = widget.phoneNumber;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idNumberController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _registerCustomer() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender == null) {
      CustomSnackBar.showError(
        context,
        title: 'Error',
        message: 'Please select a gender',
      );
      return;
    }
    if (_selectedDay == null ||
        _selectedMonth == null ||
        _selectedYear == null) {
      CustomSnackBar.showError(
        context,
        title: 'Error',
        message: 'Please select your date of birth',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final chamaCubit = context.read<ChamaCubit>();
      final dob =
          '$_selectedYear-' +
          _selectedMonth!.toString().padLeft(2, '0') +
          '-' +
          _selectedDay!.toString().padLeft(2, '0');

      await chamaCubit.registerCustomer(
        phoneNumber: _phoneNumberController.text,
        dob: dob,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        gender: _selectedGender!,
        idNumber: _idNumberController.text,
        agentId: widget.agentId,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    double screenWidth,
    Color cardColor,
    Color textColor,
    Color hintTextColor, [
    bool enabled = true,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            style: GoogleFonts.montserrat(color: textColor),
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.montserrat(color: hintTextColor),
              filled: true,
              fillColor: cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>(
    String hint,
    List<T> items,
    T? selectedValue,
    Function(T?) onChanged,
    double screenWidth,
    Color cardColor,
    Color textColor,
    Color hintTextColor,
  ) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      value: selectedValue,
      decoration: InputDecoration(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      hint: Text(hint, style: GoogleFonts.montserrat(color: hintTextColor)),
      dropdownColor: cardColor,
      style: GoogleFonts.montserrat(
        color: textColor,
        fontSize: screenWidth * 0.04,
      ),
      items:
          items
              .map(
                (value) => DropdownMenuItem<T>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: GoogleFonts.montserrat(
                      color: textColor,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
              )
              .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return ''; // Validator text handled by the row's error message
        }
        return null;
      },
    );
  }

  Widget _buildGenderOption(
    String gender,
    IconData icon,
    Color color,
    double screenWidth,
    Color textColor,
  ) {
    final bool isSelected = _selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = gender;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade400,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              SizedBox(width: 8),
              Text(
                gender,
                style: GoogleFonts.montserrat(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.06;
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color cardColor = isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100;
    Color hintTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey;
    Color buttonColor = Colors.orange;

    return BlocListener<ChamaCubit, ChamaState>(
      listener: (context, state) {
        if (state is ChamaSuccess) {
          CustomSnackBar.showSuccess(
            context,
            title: 'Success',
            message: 'Customer registered successfully',
          );
          Navigator.pop(context, true); // Return true to indicate success
          // Navigate to ChamaTypePage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider(
                    create:
                        (context) => ChamaProductsCubit(chamaRepo: ChamaRepo()),
                    child: ChamaTypePage(
                      phoneNumber: _phoneNumberController.text,
                    ),
                  ),
            ),
          );
        } else if (state is ChamaError) {
          CustomSnackBar.showError(
            context,
            title: 'Error',
            message: state.message,
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Text(
            "New Customer Registration",
            style: GoogleFonts.montserrat(
              color: textColor,
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Onboard Customer",
                  style: GoogleFonts.montserrat(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  "First Name",
                  "Enter First Name",
                  _firstNameController,
                  screenWidth,
                  cardColor,
                  textColor,
                  hintTextColor,
                ),
                _buildTextField(
                  "Last Name",
                  "Enter Last Name",
                  _lastNameController,
                  screenWidth,
                  cardColor,
                  textColor,
                  hintTextColor,
                ),
                _buildTextField(
                  "ID Number",
                  "Enter ID Number",
                  _idNumberController,
                  screenWidth,
                  cardColor,
                  textColor,
                  hintTextColor,
                ),
                _buildTextField(
                  "Phone Number",
                  "Enter Phone Number",
                  _phoneNumberController,
                  screenWidth,
                  cardColor,
                  textColor,
                  hintTextColor,
                  true,
                ), // Make phone number editable
                SizedBox(height: 10),
                Text(
                  "Birthday ",
                  style: GoogleFonts.montserrat(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown<int?>(
                        "Day",
                        _days,
                        _selectedDay,
                        (value) => setState(() => _selectedDay = value),
                        screenWidth,
                        cardColor,
                        textColor,
                        hintTextColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdown<int?>(
                        "Month",
                        _months,
                        _selectedMonth,
                        (value) => setState(() => _selectedMonth = value),
                        screenWidth,
                        cardColor,
                        textColor,
                        hintTextColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdown<int?>(
                        "Year",
                        _years,
                        _selectedYear,
                        (value) => setState(() => _selectedYear = value),
                        screenWidth,
                        cardColor,
                        textColor,
                        hintTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Gender",
                  style: GoogleFonts.montserrat(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    _buildGenderOption(
                      "Male",
                      Icons.male,
                      Colors.blue,
                      screenWidth,
                      textColor,
                    ),
                    SizedBox(width: 10),
                    _buildGenderOption(
                      "Female",
                      Icons.female,
                      Colors.pink,
                      screenWidth,
                      textColor,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: screenWidth * 0.15,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _registerCustomer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              "Register Account",
                              style: GoogleFonts.montserrat(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
