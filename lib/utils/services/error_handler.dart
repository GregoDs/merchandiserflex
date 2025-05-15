import 'package:dio/dio.dart';

class ErrorHandler {
  static String handleError(DioException error) {
    if (error.response != null) {
      // Check if the response contains error messages in the format provided
      if (error.response?.data != null &&
          error.response?.data is Map<String, dynamic>) {
        final responseData = error.response?.data;

        //prioritize errors field if it exists
        if (responseData['errors'] != null) {
          final errors = responseData['errors'];
          if (errors is List && errors.isNotEmpty) {
            return errors.join(', ');
          }
          if (errors is String) {
            return errors; // Return single error message
          }
        }
        // Handle 400 status code with specific error message
        if (error.response?.statusCode == 400 && responseData['data'] != null) {
          final errorMessage = responseData['data'];
          if (errorMessage is List && errorMessage.isNotEmpty) {
            return errorMessage.join(', '); // Join multiple error messages
          }
          if (errorMessage is String) {
            return errorMessage; // Return single error message
          }
        }

        // Handle other status codes with 'message' field
        if (responseData['message'] != null) {
          return responseData['message'];
        }
      }

      // Fallback to status code based error messages
      switch (error.response?.statusCode) {
        case 400:
          return "Bad request. Please check your input.";
        case 401:
          return "Unauthorized. Please log in again.";
        case 403:
          return "Forbidden. You don't have permission to access this resource.";
        case 404:
          return "Resource not found. Please try again.";
        case 422:
          return "Validation error. Please check your input.";
        case 500:
          return "Internal server error. Please try again later.";
        case 503:
          return "Service unavailable. Please try again later.";
        default:
          return "Unexpected error: ${error.response?.statusCode}. Please try again later.";
      }
    } else if (error.type == DioErrorType.connectionTimeout) {
      return "Connection timeout. Please check your internet connection.";
    } else if (error.type == DioErrorType.receiveTimeout) {
      return "Receive timeout. Please check your internet connection.";
    } else if (error.type == DioErrorType.sendTimeout) {
      return "Send timeout. Please check your internet connection.";
    } else if (error.type == DioErrorType.cancel) {
      return "Request was cancelled. Please try again.";
    } else if (error.type == DioErrorType.unknown) {
      return "Something went wrong. Please check your internet connection.";
    } else {
      return "An unexpected error occurred. Please try again.";
    }
  }
}
