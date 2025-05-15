import 'dart:convert';
import 'dart:developer' as dev;
import 'package:shared_preferences/shared_preferences.dart';


// Pretty Print Helper
String prettyPrintJson(dynamic jsonObj) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(jsonObj);
}



class SharedPreferencesHelper {
  static const String _tokenKey = 'token';
  static const String _userDataKey = 'user_data';
  static const String _bookingResponseKey = 'booking_response';
  static const String _bookingReferenceKey = 'booking_reference';
  static const String _validatedAmountKey = 'validated_amount';

  // Token Handling
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setBool('isLoggedIn', true);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.setBool('isLoggedIn', false);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
    await prefs.remove(_bookingReferenceKey);
    await prefs.remove(_validatedAmountKey);
    await prefs.remove(_bookingResponseKey);
    await prefs.setBool('isLoggedIn', false);

    print("User successfully logged out");
  }

  // User Data Handling
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString == null) return null;

    try {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    } catch (e) {
      print("Failed to decode user data: $e");
      return null;
    }
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);

  }

  

  static Future<void> clearBookingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookingReferenceKey);
    await prefs.remove(_validatedAmountKey);
    await prefs.remove(_bookingResponseKey);
    print("Booking data cleared");
  }

}