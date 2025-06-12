import 'package:flexmerchandiser/exports.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(
        seconds: 30,
      ), // Increased from 5 to 30 seconds
      receiveTimeout: const Duration(
        seconds: 30,
      ), // Increased from 5 to 30 seconds
      sendTimeout: const Duration(seconds: 30), // Added send timeout
    ),
  );

  // Base URLs
  static String prodEndpointAuth = dotenv.env["PROD_ENDPOINT_AUTH"]!;
  static String prodEndpointBookings = dotenv.env['PROD_ENDPOINT_BOOKINGS']!;

  // Generic GET request
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _buildHeaders(
        requiresAuth,
        url,
      ); // Pass url to buildHeaders
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      print("GET Request to $url succeeded with response: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("GET Request to $url failed with error: ${e.message}");
      throw _handleDioError(e);
    }
  }

  // Generic POST request
  Future<Response> post(
    String url, {
    dynamic data,
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _buildHeaders(
        requiresAuth,
        url,
      ); // Pass url to buildHeaders
      print("Sending POST to $url with data: ${jsonEncode(data)}"); // Add this
      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      print("Received response: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("Error details: ${e.response?.data}"); // Add this
      throw _handleDioError(e);
    }
  }

  // Generic PUT request
  Future<Response> put(
    String url, {
    Map<String, dynamic>? data,
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _buildHeaders(
        requiresAuth,
        url,
      ); // Pass url to buildHeaders
      final response = await _dio.put(
        url,
        data: data,
        options: Options(headers: headers),
      );
      print("PUT Request to $url succeeded with response: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("PUT Request to $url failed with error: ${e.message}");
      throw _handleDioError(e);
    }
  }

  // Generic DELETE request
  Future<Response> delete(
    String url, {
    Map<String, dynamic>? data,
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _buildHeaders(
        requiresAuth,
        url,
      ); // Pass url to buildHeaders
      final response = await _dio.delete(
        url,
        data: data,
        options: Options(headers: headers),
      );
      print("DELETE Request to $url succeeded with response: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("DELETE Request to $url failed with error: ${e.message}");
      throw _handleDioError(e);
    }
  }

  // Build headers with optional token
  Future<Map<String, String>> _buildHeaders(
    bool requiresAuth, [
    String? url,
  ]) async {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (requiresAuth) {
      String? token;
      // Check if this is the specific chama products endpoint
      if (url == 'https://www.flexpay.co.ke/users/api/flex-chama/products') {
        // Read token directly from .env for this specific endpoint
        token = dotenv.env['CHAMA_API_TOKEN'];
      } else {
        // For all other authenticated requests, use the token from SharedPreferences
        token = await SharedPreferencesHelper.getToken();
      }

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Exception _handleDioError(DioException error) {
    if (error.response != null && error.response?.data != null) {
      final responseData = error.response?.data;

      // Check if the backend error contains a "data" field with error details
      if (responseData is Map<String, dynamic> &&
          responseData['data'] != null) {
        final errorDetails = responseData['data'];
        if (errorDetails is Map<String, dynamic>) {
          // Format the error details into a readable string
          final errorMessage = errorDetails.entries
              .map((entry) => '${entry.key}: ${entry.value.join(', ')}')
              .join('; ');
          return Exception(errorMessage);
        }
      }

      // Fallback to the "message" field if available
      if (responseData['message'] != null) {
        return Exception(responseData['message']);
      }
    }

    // Default error message if no specific details are available
    return Exception(ErrorHandler.handleError(error));
  }
}
