import 'package:flexmerchandiser/exports.dart';
import 'package:flexmerchandiser/features/home/models/outlets_model.dart';

class HomeRepo {
  final ApiService _apiService = ApiService();

  Future<List<Outlet>> fetchOutlets() async {
    try {
      // Get the stored user data
      final userData = await SharedPreferencesHelper.getUserData();
      if (userData == null) {
        throw Exception('User data not found. Please login again.');
      }

      // Parse the stored user data
      final userModel = UserModel.fromJson(userData);
      final userId = userModel.user.id.toString();

      final response = await _apiService.post(
        'https://bookings.flexpay.co.ke/api/merchandizer/outlets',
        data: {'user_id': userId},
      );

      // 🔍 Log the response data
      print('🔁 API Response: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final outletListJson = responseData['data'] as List<dynamic>;
        return outletListJson
            .map((json) => Outlet.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to fetch outlets',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
