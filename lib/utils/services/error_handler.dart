import 'package:dio/dio.dart';

class ErrorHandler {
  static String handleError(DioException error) {
    if (error.response != null) {
      // Check if the response contains error messages in the format provided
      if (error.response?.data != null &&
          error.response?.data is Map<String, dynamic>) {
        final responseData = error.response?.data;

        // Check for specific validation errors in 'errors' field (can be List or Map)
        if (responseData['errors'] != null) {
          final errors = responseData['errors'];
          if (errors is List && errors.isNotEmpty) {
            // Handle errors as a list of strings
            return errors.join(', ');
          } else if (errors is String) {
            // Handle errors as a single string
            return errors;
          } else if (errors is Map) {
            // Handle errors as a map (common for validation errors like 422)
            final errorMessages = <String>[];
            errors.forEach((key, value) {
              if (value is List) {
                errorMessages.add('$key: ${value.join(', ')}');
              } else if (value is String) {
                errorMessages.add('$key: $value');
              } else {
                errorMessages.add(value.toString());
              }
            });
            if (errorMessages.isNotEmpty) {
              return errorMessages.join('; ');
            }
          }
        }

        // Handle 400 status code with specific error message in 'data' field
        if (error.response?.statusCode == 400 && responseData['data'] != null) {
          final errorMessage = responseData['data'];
          if (errorMessage is List && errorMessage.isNotEmpty) {
            return errorMessage.join(', '); // Join multiple error messages
          } else if (errorMessage is String) {
            return errorMessage; // Return single error message
          }
        }

        // Handle other status codes with 'message' field
        if (responseData['message'] != null) {
          // Check if message is a string or potentially a list/map that needs formatting
          final message = responseData['message'];
          if (message is String) {
            return message;
          } else {
            // Attempt to convert other message types to string or format
            return message.toString(); // Fallback to string representation
          }
        }
      }

      // Fallback to status code based error messages if no specific message found in data
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
          return "Validation error. Please check your input."; // Keep as fallback, specific handled above
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
      // Check if there's an underlying OS error, e.g., network issue
      if (error.error != null && error.error is Object) {
        // Attempt to extract a more specific message from the underlying error
        return "Network error: ${error.error.toString()}";
      } else {
        return "Something went wrong. Please check your internet connection.";
      }
    } else {
      return "An unexpected error occurred. Please try again.";
    }
  }
}
