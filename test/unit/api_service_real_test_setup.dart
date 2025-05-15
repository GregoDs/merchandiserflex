import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDio extends Mock implements Dio {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

// Helper to create mock responses
Response<dynamic> mockSuccessResponse({
  dynamic data,
  int statusCode = 200,
  String path = '/test',
}) {
  return Response(
    data: data ?? {'success': true},
    statusCode: statusCode,
    requestOptions: RequestOptions(path: path),
  );
}

DioException mockDioError({
  int? statusCode,
  dynamic data,
  String path = '/test',
  DioExceptionType type = DioExceptionType.badResponse,
}) {
  return DioException(
    requestOptions: RequestOptions(path: path),
    response: Response(
      data: data,
      statusCode: statusCode,
      requestOptions: RequestOptions(path: path),
    ),
    type: type,
  );
}