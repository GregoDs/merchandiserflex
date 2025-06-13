import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../cubit/leads_cubit.dart';
import '../cubit/leads_state.dart';
import '../models/leads_model.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/custom_snackbar.dart';
import 'package:flexmerchandiser/utils/cache/shared_preferences_helper.dart';
import 'package:flexmerchandiser/features/auth/models/user_model.dart';

class AddLeadPage extends StatefulWidget {
  const AddLeadPage({super.key});

  @override
  State<AddLeadPage> createState() => _AddLeadPageState();
}

class _AddLeadPageState extends State<AddLeadPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _descController = TextEditingController();

  bool _submitted = false;
  bool _showAnimation = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Set a default duration
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _descController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showSuccessAnimation() {
    setState(() {
      _showAnimation = true;
    });
    _animationController.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showAnimation = false;
              // Clear form fields
            _phoneController.clear();
            _firstNameController.clear();
            _lastNameController.clear();
            _descController.clear();
            _submitted = false;
          });
          _animationController.reset();
          // Reset Cubit state to initial
          context.read<LeadsCubit>().emit(const LeadsInitial());
        }
      });
    });
  }

  void _submit(BuildContext context) async {
    setState(() => _submitted = true);
    if (_formKey.currentState?.validate() ?? false) {
      // Fetch user data from shared preferences
      final userData = await SharedPreferencesHelper.getUserData();
      if (userData == null) {
        CustomSnackBar.showError(
          context,
          title: "Error",
          message: "User not logged in.",
        );
        return;
      }
      final userId = UserModel.fromJson(userData).user.id.toString();

      final cubit = context.read<LeadsCubit>();
      final lead = LeadRequest(
        promoterUserId: userId,
        customerPhone: _phoneController.text.trim(),
        customerFirstName: _firstNameController.text.trim(),
        customerLastName: _lastNameController.text.trim(),
        description: _descController.text.trim(),
      );
      cubit.createLead(lead);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.06;
    final cardColor = Colors.grey.shade900;
    final textColor = Colors.white;
    final hintTextColor = Colors.grey.shade400;
    final buttonColor = Colors.orange;

    return BlocConsumer<LeadsCubit, LeadsState>(
      listener: (context, state) {
        if (state is LeadsSuccess) {
          _showSuccessAnimation();
          print("Lead Success: ${state.lead}");
        } else if (state is LeadsError) {
          print("Lead Error: ${state.message}");
          CustomSnackBar.showError(
            context,
            title: "Error",
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        if (state is LeadsLoading) {
          return const LoadingPage(color: Colors.white);
        }
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/appbarbackground.png",
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).maybePop(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
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
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Add a Refferal Lead here",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 8, bottom: 16),
                          child: Form(
                            key: _formKey,
                            autovalidateMode: _submitted
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLeadField(
                                  label: "First Name",
                                  hint: "Enter First Name",
                                  controller: _firstNameController,
                                  icon: Icons.person_outline,
                                  cardColor: cardColor,
                                  textColor: textColor,
                                  hintTextColor: hintTextColor,
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty ? "First name is required" : null,
                                ),
                                _buildLeadField(
                                  label: "Last Name",
                                  hint: "Enter Last Name",
                                  controller: _lastNameController,
                                  icon: Icons.person_outline,
                                  cardColor: cardColor,
                                  textColor: textColor,
                                  hintTextColor: hintTextColor,
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty ? "Last name is required" : null,
                                ),
                                _buildLeadField(
                                  label: "Phone Number",
                                  hint: "e.g. 0704667813",
                                  controller: _phoneController,
                                  icon: Icons.phone,
                                  cardColor: cardColor,
                                  textColor: textColor,
                                  hintTextColor: hintTextColor,
                                  keyboardType: TextInputType.phone,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return "Phone is required";
                                    }
                                    if (!RegExp(r'^0\d{9}$').hasMatch(v.trim())) {
                                      return "Enter a valid phone (e.g. 07XXXXXXXX)";
                                    }
                                    return null;
                                  },
                                ),
                                _buildLeadField(
                                  label: "Description",
                                  hint: "Short description (optional)",
                                  controller: _descController,
                                  icon: Icons.description_outlined,
                                  cardColor: cardColor,
                                  textColor: textColor,
                                  hintTextColor: hintTextColor,
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  height: screenWidth * 0.15,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _submit(context),
                                    icon: const Icon(Icons.send, color: Colors.white),
                                    label: Text(
                                      "Submit",
                                      style: GoogleFonts.montserrat(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 2,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showAnimation)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: Colors.black.withOpacity(0.1),
                      child: Lottie.asset(
                        'assets/images/success.json',
                        controller: _animationController,
                        fit: BoxFit.contain,
                        onLoaded: (composition) {
                          _animationController.duration = composition.duration;
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeadField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required Color cardColor,
    required Color textColor,
    required Color hintTextColor,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
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
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            style: GoogleFonts.montserrat(color: textColor),
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: hintTextColor),
              hintText: hint,
              hintStyle: GoogleFonts.montserrat(color: hintTextColor),
              filled: true,
              fillColor: cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Colors.orange.withOpacity(0.7),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}