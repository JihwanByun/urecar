import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final MainController controller = Get.put(MainController());
  String? baseUrl = dotenv.env['FLUTTER_APP_SERVER_URL'];

  Future<dynamic> signUp(Map<String, dynamic> formData) async {
    final url = Uri.parse('$baseUrl/members/signup');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> emailCheck(Map<String, dynamic> formData) async {
    final url = Uri.parse('$baseUrl/members/emailCheck');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );
      if (response.statusCode == 200) {
        if (response.body == "true") {
          return true;
        } else {
          return false;
        }
      } else {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> login(Map<String, dynamic> formData) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        final responseData = jsonDecode(response.body);
      }
    } catch (e) {
      return e;
    }
  }
}
