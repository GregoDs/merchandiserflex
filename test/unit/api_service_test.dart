
// import 'package:flexmerchandiser/utils/cache/shared_preferences_helper.dart';
// import 'package:flexmerchandiser/utils/services/api_service.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:dio/dio.dart';
// import 'package:mockito/mockito.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'api_service_real_test_setup.dart';


// void main() {
//   late ApiService apiService;
//   late MockDio mockDio;
//   late MockSharedPreferences mockSharedPreferences;

//   const testToken = 'test_auth_token';
//   const testUrl = 'https://api.example.com/test';
//   final testData = {'key': 'value'};
//   final testQueryParams = {'param': 'value'};

//   setUp(() {
//     mockDio = MockDio();
//     mockSharedPreferences = MockSharedPreferences();
    
//     // Setup SharedPreferences mock
//     SharedPreferencesHelper.setMockInitialValues(mockSharedPreferences);
    
//     // Initialize ApiService with mock Dio
//     apiService = ApiService().._dio = mockDio;
    
//     // Setup environment variables for testing
//     apiService.prodEndpointAuth = 'https://auth.example.com';
//     apiService.prodEndpointBookings = 'https://bookings.example.com';
//   });

//   tearDown(() {
//     reset(mockDio);
//     reset(mockSharedPreferences);
//   });

//   group('GET requests', () {
//     test('successful GET request with auth', () async {
//       // Arrange
//       when(mockSharedPreferences.getString(any))
//           .thenReturn(testToken);
//       when(mockDio.get(
//         any,
//         queryParameters: anyNamed('queryParameters'),
//         options: anyNamed('options'),
//       )).thenAnswer((_) async => mockSuccessResponse());

//       // Act
//       final response = await apiService.get(testUrl);

//       // Assert
//       expect(response.statusCode, 200);
//       verify(mockDio.get(
//         testUrl,
//         queryParameters: null,
//         options: argThat(
//           predicate((options) => 
//             options is Options && 
//             options.headers?['Authorization'] == 'Bearer $testToken'),
//           'headers with auth token',
//         ),
//       )).called(1);
//     });

//     test('GET request with query parameters', () async {
//       // Arrange
//       when(mockDio.get(
//         any,
//         queryParameters: anyNamed('queryParameters'),
//         options: anyNamed('options'),
//       )).thenAnswer((_) async => mockSuccessResponse());

//       // Act
//       final response = await apiService.get(
//         testUrl,
//         queryParameters: testQueryParams,
//       );

//       // Assert
//       expect(response.statusCode, 200);
//       verify(mockDio.get(
//         testUrl,
//         queryParameters: testQueryParams,
//         options: anyNamed('options'),
//       )).called(1);
//     });

//     test('GET request without auth', () async {
//       // Arrange
//       when(mockDio.get(
//         any,
//         queryParameters: anyNamed('queryParameters'),
//         options: anyNamed('options'),
//       )).thenAnswer((_) async => mockSuccessResponse());

//       // Act
//       final response = await apiService.get(
//         testUrl,
//         requiresAuth: false,
//       );

//       // Assert
//       expect(response.statusCode, 200);
//       verify(mockDio.get(
//         testUrl,
//         queryParameters: null,
//         options: argThat(
//           predicate((options) => 
//             options is Options && 
//             options.headers?['Authorization'] == null),
//           'headers without auth token',
//         ),
//       )).called(1);
//     });
//   });

//   group('POST requests', () {
//     test('successful POST request', () async {
//       // Arrange
//       when(mockDio.post(
//         any,
//         data: anyNamed('data'),
//         options: anyNamed('options'),
//       )).thenAnswer((_) async => mockSuccessResponse(statusCode: 201));

//       // Act
//       final response = await apiService.post(
//         testUrl,
//         data: testData,
//       );

//       // Assert
//       expect(response.statusCode, 201);
//       verify(mockDio.post(
//         testUrl,
//         data: testData,
//         options: anyNamed('options'),
//       )).called(1);
//     });

//     test('POST request with null data', () async {
//       // Arrange
//       when(mockDio.post(
//         any,
//         data: anyNamed('data'),
//         options: anyNamed('options'),
//       )).thenAnswer((_) async => mockSuccessResponse(statusCode: 201));

//       // Act
//       final response = await apiService.post(testUrl);

//       // Assert
//       expect(response.statusCode, 201);
//       verify(mockDio.post(
//         testUrl,
//         data: null,
//         options: anyNamed('options'),
//       )).called(1);
//     });
//   });

//   group('Error handling', () {
//     test('handles DioException with backend error format', () async {
//       // Arrange
//       final errorData = {
//         'message': 'Validation failed',
//         'data': {'email': ['Invalid format'], 'password': ['Too short']}
//       };
      
//       when(mockDio.get(any))
//           .thenThrow(mockDioError(
//             statusCode: 400,
//             data: errorData,
//           ));

//       // Act & Assert
//       expect(
//         () => apiService.get(testUrl),
//         throwsA(isA<Exception>().having(
//           (e) => e.toString(),
//           'error message',
//           contains('email: Invalid format; password: Too short'),
//         )),
//       );
//     });

//     test('handles DioException with simple message', () async {
//       // Arrange
//       final errorData = {'message': 'Resource not found'};
      
//       when(mockDio.get(any))
//           .thenThrow(mockDioError(
//             statusCode: 404,
//             data: errorData,
//           ));

//       // Act & Assert
//       expect(
//         () => apiService.get(testUrl),
//         throwsA(isA<Exception>().having(
//           (e) => e.toString(),
//           'error message',
//           contains('Resource not found'),
//         )),
//       );
//     });

//     test('handles DioException without response data', () async {
//       // Arrange
//       when(mockDio.get(any))
//           .thenThrow(mockDioError(
//             type: DioExceptionType.connectionTimeout,
//           ));

//       // Act & Assert
//       expect(
//         () => apiService.get(testUrl),
//         throwsA(isA<Exception>()),
//       );
//     });
//   });

//   group('Headers construction', () {
//     test('includes auth token when required and available', () async {
//       // Arrange
//       when(mockSharedPreferences.getString(any))
//           .thenReturn(testToken);
//       when(mockDio.get(any))
//           .thenAnswer((_) async => mockSuccessResponse());

//       // Act
//       await apiService.get(testUrl);

//       // Assert
//       verify(mockDio.get(
//         any,
//         options: argThat(
//           predicate((options) {
//             final headers = (options as Options).headers;
//             return headers?['Authorization'] == 'Bearer $testToken' &&
//                    headers?['Content-Type'] == 'application/json';
//           },
//           'headers with auth token',
//         ),
//       ));
//     });

//     test('does not include auth token when not required', () async {
//       // Arrange
//       when(mockDio.get(any))
//           .thenAnswer((_) async => mockSuccessResponse());

//       // Act
//       await apiService.get(testUrl, requiresAuth: false);

//       // Assert
//       verify(mockDio.get(
//         any,
//         options: argThat(
//           predicate((options) {
//             final headers = (options as Options).headers;
//             return headers?['Authorization'] == null &&
//                    headers?['Content-Type'] == 'application/json';
//           },
//           'headers without auth token',
//         ),
//       ));
//     });

//     test('handles missing auth token when required', () async {
//       // Arrange
//       when(mockSharedPreferences.getString(any))
//           .thenReturn(null);
//       when(mockDio.get(any))
//           .thenAnswer((_) async => mockSuccessResponse());

//       // Act
//       await apiService.get(testUrl);

//       // Assert
//       verify(mockDio.get(
//         any,
//         options: argThat(
//           predicate((options) {
//             final headers = (options as Options).headers;
//             return headers?['Authorization'] == null &&
//                    headers?['Content-Type'] == 'application/json';
//           },
//           'headers without auth token',
//         ),
//         )
//       ));
//     });
//   });

//   group('Timeout configuration', () {
//     test('has correct timeout values', () {
//       expect(apiService._dio.options.connectTimeout, const Duration(seconds: 30));
//       expect(apiService._dio.options.receiveTimeout, const Duration(seconds: 30));
//       expect(apiService._dio.options.sendTimeout, const Duration(seconds: 30));
//     });
//   });
// }