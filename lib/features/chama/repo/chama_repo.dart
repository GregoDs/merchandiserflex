import 'package:flexmerchandiser/exports.dart';
import 'package:flexmerchandiser/features/chama/models/chama_registration_model.dart';
import 'package:flexmerchandiser/features/chama/models/chama_type_model.dart';
import 'package:flexmerchandiser/features/chama/models/chama_subscription_model.dart';

class ChamaRepo {
  final ApiService _apiService = ApiService();

  Future<ChamaRegistrationResponse> registerCustomer({
    required String phoneNumber,
    required String dob,
    required String firstName,
    required String lastName,
    required String gender,
    required String idNumber,
    required int agentId,
  }) async {
    try {
      final response = await _apiService.post(
        'https://www.flexpay.co.ke/users/api/flex-chama/join',
        data: {
          "phone_number": phoneNumber,
          "dob": dob,
          "first_name": firstName,
          "last_name": lastName,
          "gender": gender.toLowerCase(),
          "id_number": idNumber,
          "agent_id": 309731,
        },
      );

      if (response.statusCode == 200) {
        final registrationResponse = ChamaRegistrationResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        if (registrationResponse.success) {
          return registrationResponse;
        } else {
          throw Exception(
            registrationResponse.errors.join(', ') ??
                'Failed to register customer',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to register customer (HTTP ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error in registerCustomer: $e');
      rethrow;
    }
  }

  Future<ChamaProductsResponse> fetchChamaProducts(String type) async {
    try {
      final response = await _apiService.post(
        'https://www.flexpay.co.ke/users/api/flex-chama/products',
        data: {'type': type},
        requiresAuth: true, // Requires authentication
      );

      if (response.statusCode == 200) {
        return ChamaProductsResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to fetch chama products (HTTP ${response.statusCode})',
        );
      }
    } on DioException catch (dioError) {
      rethrow;
    } catch (e) {
      print('Error in fetchChamaProducts: $e');
      rethrow;
    }
  }

  Future<ChamaSubscriptionResponse> subscribeToChama({
    required String phoneNumber,
    required int productId,
    required double depositAmount,
  }) async {
    try {
      final response = await _apiService.post(
        'https://www.flexpay.co.ke/users/api/flex-chama/subscribe',
        data: {
          'phone_number': phoneNumber,
          'product_id': productId,
          'deposit_amount': depositAmount,
        },
        requiresAuth: true,
      );

      print('Chama Subscription Request: ${response.data}'); // Log request
      print('Chama Subscription Response: ${response.data}'); // Log response

      if (response.statusCode == 200) {
        return ChamaSubscriptionResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to subscribe to chama (HTTP ${response.statusCode})',
        );
      }
    } on DioException catch (dioError) {
      rethrow;
    } catch (e) {
      print('Error in subscribeToChama: $e');
      rethrow;
    }
  }

//   Future<ChamaProductsResponse> fetchChamaProducts(String type) async {
//   final response = await _apiService.post(
//     'https://www.flexpay.co.ke/users/api/flex-chama/products',
//     data: {'type': type},
//     requiresAuth: true,
//   );

//   return ChamaProductsResponse.fromJson(
//     response.data as Map<String, dynamic>,
//   );
// }
}
