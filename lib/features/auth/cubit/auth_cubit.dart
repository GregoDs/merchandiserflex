import 'package:bloc/bloc.dart';
import 'package:flexmerchandiser/exports.dart';
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
        emit(
          AuthOtpSent(
            message: response.data['message'] ?? 'OTP sent successfully',
          ),
        );

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
        //verify the token
        final token = await SharedPreferencesHelper.getToken();
        final verifyTokenResponse = await _authRepo.verifyToken(token ?? "");

        if (verifyTokenResponse.data["success"] == true) {
          // Emit user updated state with the updated UserModel
          emit(AuthUserUpdated(userModel: _authRepo.userModel!));
        } else {
          //Token is invalid
          emit(AuthTokenInvalid());
        }
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

        //Verify token here to proceed to the next page
      }
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  Future<void> verifyTokenOnStartup() async {
    emit(AuthLoading());
    try {
      final token = await SharedPreferencesHelper.getToken();
      if (token == null) {
        emit(AuthTokenInvalid());
        return;
      }
      final response = await _authRepo.verifyToken(token);
      if (response.data['success'] == true) {
        final userJson = response.data['data']?['user'];
        if (userJson != null) {
          final userModel = UserModel(
            token: token,
            user: User(
              id: userJson["id"] ?? 0,
              email: userJson["email"] ?? "",
              userType: userJson["user_type"] ?? 0,
              isVerified: userJson["is_verified"] ?? 0,
              phoneNumber: userJson["phone_number"] ?? 0,
            ),
          );
          _authRepo.setUserModel(userModel);
          emit(AuthUserUpdated(userModel: userModel));
        } else {
          emit(AuthTokenInvalid());
        }
      } else {
        emit(AuthTokenInvalid());
      }
    } catch (e) {
      emit(AuthTokenInvalid());
    }
  }
}
