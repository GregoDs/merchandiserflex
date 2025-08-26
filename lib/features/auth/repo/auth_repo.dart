import 'package:flexmerchandiser/utils/services/api_service.dart';
import 'package:flexmerchandiser/exports.dart';

class AuthRepo {
  final ApiService _apiService = ApiService();

  UserModel? _userModel;

  // Function to request OTP
  Future<Response> requestOtp(String phoneNumber) async {
    try {
      final endpoint = dotenv.env["PROD_ENDPOINT_AUTH"];
      if (endpoint == null) {
        throw Exception("PROD_ENDPOINT_AUTH is not set in .env");
      }

      final String url = "$endpoint/promoter/send-otp";

      final response = await _apiService.post(
        url,
        data: {"phone_number": phoneNumber},
        requiresAuth: false,
      );

      _userModel = UserModel(
        token: "",
        user: User(
          id: 0,
          email: "",
          userType: 0,
          isVerified: 0,
          phoneNumber: int.tryParse(phoneNumber) ?? 0,
        ),
      );

      print("OTP request succeeded: ${response.data}");
      return response;
    } on DioException catch (e) {
      // print("OTP request failed: ${e.message}");
      final errorMessage = ErrorHandler.handleError(e);
      throw Exception(errorMessage);
    } catch (e) {
      print("Unexpected error during OTP request: $e");
      rethrow;
    }
  }

  // Function to verify OTP
  Future<Response> verifyOtp(String phoneNumber, String otp) async {
    try {
      final endpoint = dotenv.env["PROD_ENDPOINT_AUTH"];
      if (endpoint == null) {
        throw Exception("PROD_ENDPOINT_AUTH is not set in .env");
      }

      final String url = "$endpoint/promoter/verify-otp";

      final response = await _apiService.post(
        url,
        data: {"phone_number": phoneNumber, "otp": otp},
        requiresAuth: false,
      );

      final responseData = response.data["data"];
      if (responseData == null || responseData["user"] == null) {
        throw Exception("Invalid response data");
      }

      _userModel = UserModel(
        token: responseData["token"] ?? "",
        user: User(
          id: responseData["user"]["id"] ?? 0,
          email: responseData["user"]["email"] ?? "",
          userType: responseData["user"]["user_type"] ?? 0,
          isVerified: responseData["user"]["is_verified"] ?? 0,
          phoneNumber: responseData["user"]["phone_number"] ?? 0,
        ),
      );

      await SharedPreferencesHelper.saveUserData(response.data);
      await SharedPreferencesHelper.saveToken(responseData["token"] ?? "");
      print("Saved token: ${responseData["token"]}");

      // Set firstLaunch to false after successful login/OTP
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('firstLaunch', false);

      print("OTP verification succeeded: ${response.data}");
      return response;
    } on DioException catch (e) {
      // print("OTP verification failed: ${e.message}");
      final errorMessage = ErrorHandler.handleError(e);
      throw Exception(errorMessage);
    } catch (e) {
      print("Unexpected error during OTP verification: $e");
      rethrow;
    }
  }

  //Verify token
  Future<Response> verifyToken(String token) async {
    try {
      final endpoint = dotenv.env["PROD_ENDPOINT_AUTH_VERIFYTKN"];
      if (endpoint == null) {
        throw Exception('PROD_ENDPOINT_AUTH_VERIFYTKN is not set in .enc');
      }
      final String url = "$endpoint/verify-token";

      final response = await _apiService.get(
        url,
        requiresAuth: true,
      );
      return response;
    } catch (e) {
      print("Unexpected error during token verification: $e");
      rethrow;
    }
  }

  void setUserModel(UserModel userModel) {
    _userModel = userModel;
  }

  UserModel? get userModel => _userModel;

  // Delete Account Function
  Future<Response> deleteAccount() async {
    // Fetch user data
    final userData = await SharedPreferencesHelper.getUserData();
    if (userData == null) {
      throw Exception('User data not found. Please login again.');
    }
    final userModel = UserModel.fromJson(userData);
    final localUserId = userModel.user.id.toString();

    const String url =
        "https://www.flexpay.co.ke/users/api/delete-customer-data";

    final response = await _apiService.post(
      url,
      data: {'user_id': localUserId},
      requiresAuth: true,
    );

    return response;
  }

  // Logout function
  Future<void> logout() async {
    await SharedPreferencesHelper.clearToken();
    await SharedPreferencesHelper.clearUserData();
  }
}
