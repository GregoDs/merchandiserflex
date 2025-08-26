import 'dart:developer';
import 'package:flexmerchandiser/features/leads/models/leads_model.dart';
import 'package:flexmerchandiser/utils/services/api_service.dart';
import 'package:flexmerchandiser/utils/services/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LeadsRepo {
  final ApiService _apiService = ApiService();

  Future<LeadResponse> createLead(LeadRequest request) async {
    try {
      final String baseUrl = dotenv.env['PROD_ENDPOINT_LEADS']!;
      final String url = '$baseUrl/leads';

      final response = await _apiService.post(
        url,
        data: request.toJson(),
        requiresAuth: true,
      );

      print("LeadsRepo: Response data: ${response.data}");
      log("LeadsRepo: Response data: ${response.data}");

      final leadJson = response.data['data'];
      if (leadJson == null) {
        throw Exception('Lead data not found in response');
      }
      return LeadResponse.fromJson(leadJson);
    } on DioException catch (e) {
      print("LeadsRepo: DioException: ${e.response?.data ?? e.message}");
      log("LeadsRepo: DioException: ${e.response?.data ?? e.message}");
      throw Exception(ErrorHandler.handleError(e));
    } catch (e) {
      print("LeadsRepo: Unknown error: $e");
      log("LeadsRepo: Unknown error: $e");
      throw Exception('Failed to create lead: $e');
    }
  }
}