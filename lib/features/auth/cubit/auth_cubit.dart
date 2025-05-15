import 'package:bloc/bloc.dart';
import 'package:flexmerchandiser/features/auth/repo/auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  // Function to request OTP
  Future<void> requestOtp(String phoneNumber) async {
    emit(AuthLoading());
    try {
      final response = await _authRepo.requestOtp(phoneNumber);

      // Check if the response indicates success
      if (response.data['success'] == true) {
        // Emit OTP sent state with a success message
        emit(AuthOtpSent(
            message: response.data['message'] ?? 'OTP sent successfully'));

        // Emit user updated state with the updated UserModel
        emit(AuthUserUpdated(userModel: _authRepo.userModel!));
      } else {
        // Handle unsuccessful response
        final errors = response.data['errors'];
        String errorMessage = 'Failed to send OTP';

        if (errors != null) {
          if (errors is List && errors.isNotEmpty) {
            errorMessage = errors[0].toString();
          } else if (errors is String) {
            errorMessage = errors;
          }
        }

        emit(AuthError(errorMessage: errorMessage));
      }
    } catch (e) {
      // Emit error state with the error message
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  //Function to verify the otp
  Future<void> verifyOtp(String phoneNumber, String otp) async {
    emit(AuthLoading());
    try {
      final response = await _authRepo.verifyOtp(phoneNumber, otp);

      // Check if the response indicates success
      if (response.data['success'] == true) {
        // Emit user updated state with the updated UserModel
        emit(AuthUserUpdated(userModel: _authRepo.userModel!));
      } else {
        // Handle unsuccessful response
        final errors = response.data['errors'];
        String errorMessage = 'Failed to verify OTP';

        if (errors != null) {
          if (errors is List && errors.isNotEmpty) {
            errorMessage = errors[0].toString();
          } else if (errors is String) {
            errorMessage = errors;
          }
        }

        emit(AuthError(errorMessage: errorMessage));
      }
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }
}
