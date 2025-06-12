import 'package:flexmerchandiser/exports.dart';
import 'package:flexmerchandiser/features/customers/models/customers_model.dart';

class CustomerRepo {
  final ApiService _apiService = ApiService();

  Future<CustomerData> fetchCustomers({
    required String outletId,
    int page = 1,
  }) async {
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
        'https://bookings.flexpay.co.ke/api/merchandizer/customers',
        data: {'user_id': userId, 'outlet_id': outletId, 'page': page},
      );

      // 🔍 Log the response data
      print('🔁 API Response (Customers): ${response.data}');

      if (response.statusCode == 200) {
        final customerResponse = CustomerResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        if (customerResponse.success) {
          return customerResponse.data;
        } else {
          throw Exception(
            customerResponse.errors.join(', ') ?? 'Failed to fetch customers',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to fetch customers (HTTP ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error in fetchCustomers: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateFollowUpStatus({
    required String userId,
    required String status,
    String? description,
  }) async {
    final response = await _apiService.post(
      'https://www.flexpay.co.ke/users/api/merchandizer/customer-followup',
      data: {
        'user_id': userId,
        'status': status,
        'description': description ?? '',
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<PaymentSummary?> fetchPaymentSummary(String phone) async {
    final response = await _apiService.get(
      'https://bookings.flexpay.co.ke/api/booking/customer-summary/$phone',
      requiresAuth: true,
    );
    if (response.statusCode == 200) {
      final data = response.data;
      if (data['data'] != null && data['data']['payment_summary'] != null) {
        return PaymentSummary.fromJson(data['data']['payment_summary']);
      }
    }
    return null;
  }

  Future<CustomerData> searchCustomers({
    required String userId,
    required String outletId,
    int page = 1,
    String? customerName,
    String? phone,
    String? isFlexsaveCustomer, // "yes" or "no" from UI, will convert to 1/0
    String? customerFollowup,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'user_id': userId,
        'outlet_id': outletId,
        'page': page,
      };
      if (customerName != null && customerName.isNotEmpty) {
        data['customer_name'] = customerName;
      }
      if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }
      if (isFlexsaveCustomer != null && isFlexsaveCustomer.isNotEmpty) {
        data['is_flexsave_customer'] =
            isFlexsaveCustomer.toLowerCase() == 'yes' ? 1 : 0;
      }
      if (customerFollowup != null && customerFollowup.isNotEmpty) {
        data['customer_followup'] = customerFollowup;
      }

      print('🔎 Sending search request: $data');
      final response = await _apiService.post(
        'https://bookings.flexpay.co.ke/api/merchandizer/customers',
        data: data,
      );
      print('🔁 Search API Response: ${response.data}');

      if (response.statusCode == 200) {
        final customerResponse = CustomerResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        if (customerResponse.success) {
          return customerResponse.data;
        } else {
          throw Exception(
            customerResponse.errors.join(', ') ?? 'Failed to fetch customers',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to fetch customers (HTTP ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error in searchCustomers: $e');
      rethrow;
    }
  }
}
