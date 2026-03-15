import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:questionnaire_app/constants/api_endpoints.dart';
import 'package:questionnaire_app/models/api_response.dart';
import 'package:questionnaire_app/models/user_model.dart';
import 'package:questionnaire_app/utils/prefs.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final userData = await Prefs.getMap('userdata');
    debugPrint('User data from prefs: $userData');
    isLoggedIn.value = userData != null;
  }

  Future<ApiResponse> isUserExists(String phone, String password) async {
    try {
      final endpoint = "${ApiEndpoints.users}?phone=$phone&password=$password";
      debugPrint('endpoint: $endpoint');

      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final users = data
            .map((item) => User.fromJson(item as Map<String, dynamic>))
            .toList();
        debugPrint('Users found for phone $phone: ${users.length}');

        if (users.isEmpty) {
          return ApiResponse(
            success: false,
            message: "User not found",
            data: null,
          );
        }
        return ApiResponse(
          success: true,
          message: "User found",
          data: users.first,
        );
      } else if (response.statusCode == 404) {
        return ApiResponse(
          success: false,
          message: "User not found",
          data: null,
        );
      } else {
        return ApiResponse(success: false, message: response.body, data: null);
      }
    } catch (e) {
      debugPrint('User lookup error: $e');
      return ApiResponse(success: false, message: e.toString(), data: null);
    }
  }

  Future<ApiResponse> login(String phone, String password) async {
    try {
      debugPrint('Attempting login with phone: $phone and password: $password');

      final userResponse = await isUserExists(phone, password);

      if (userResponse.success) {
        isLoggedIn.value = true;
        await Prefs.setMap('userdata', (userResponse.data as User).toJson());
      }
      return userResponse;
    } catch (e, stackTrace) {
      debugPrint('Login error: $e\n$stackTrace');
      return ApiResponse(success: false, message: e.toString(), data: null);
    }
  }

  Future<ApiResponse> register(String phone, String password) async {
    try {
      debugPrint(
        'Attempting registration with phone: $phone and password: $password',
      );

      final isUserExists = await this.isUserExists(phone, password);

      if (isUserExists.success) {
        return ApiResponse(
          success: false,
          message: "User already exists with this phone number",
          data: null,
        );
      }

      final response = await http.post(
        Uri.parse(ApiEndpoints.users),
        body: {"phone": phone, "password": password},
      );

      if (response.statusCode == 201) {
        debugPrint('Registration successful: ${response.body}');
        return ApiResponse(
          success: true,
          message: "Registration successful",
          data: User.fromJson(jsonDecode(response.body)),
        );
      } else {
        debugPrint(
          'Registration failed with status code: ${response.statusCode}',
        );
        throw Exception(
          'Registration failed with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      throw Exception('Registration error: $e');
    }
  }

  Future<void> logout() async {
    await Prefs.remove('userdata');
    isLoggedIn.value = false;
  }
}
