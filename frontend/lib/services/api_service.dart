import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final MainController controller = Get.put(MainController());
  String? baseUrl = dotenv.env['FLUTTER_APP_SERVER_URL'];

  Future<void> signUp(Map<String, dynamic> formData) async {
    final url = Uri.parse('$baseUrl/members/signup');
    final response = await http.post(
      url,
      body: jsonEncode(formData),
    );
  }

  Future<void> emailCheck(Map<String, dynamic> formData) async {
    final url = Uri.parse('$baseUrl/members/emailCheck');
    final response = await http.post(
      url,
      body: jsonEncode(formData),
    );
  }

  Future<void> login(Map<String, dynamic> formData) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      body: jsonEncode(formData),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
    }
  }
}
