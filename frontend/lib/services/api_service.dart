import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio_pkg;

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
        final responseData = jsonDecode(response.body);
        controller.accessToken.value = responseData['accessToken'];
        controller.memberId.value = responseData['memberId'];
        controller.memberName.value = responseData['memberName'];

        return response.statusCode;
      } else {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> sendFCMToken() async {
    final url = Uri.parse('$baseUrl/token');
    if (controller.memberId.value == 0 || controller.fcmToken.value == "") {
      return 0;
    }
    final formData = {
      "memberId": controller.memberId.value,
      "token": controller.fcmToken.value
    };
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(formData));
      if (response.statusCode == 200) {
        return 200;
      } else {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> withdraw(Map<String, dynamic> formData) async {
    final url = Uri.parse('$baseUrl/members');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        controller.accessToken.value = "";
        controller.memberId.value = 0;
        controller.memberName.value = "";
        await sendFCMToken();

        return response.statusCode;
      } else {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> createReport(
      Map<String, dynamic> formData, String imagePath) async {
    dio_pkg.Dio dio = dio_pkg.Dio();
    final url = '$baseUrl/reports';

    try {
      dio_pkg.FormData formDataWithFile = dio_pkg.FormData.fromMap({
        'dto': dio_pkg.MultipartFile.fromString(
          jsonEncode(formData['dto']),
          contentType: dio_pkg.DioMediaType.parse('application/json'),
        ),
        'file': await dio_pkg.MultipartFile.fromFile(imagePath)
      });
      dio_pkg.Response response = await dio.post(
        url,
        data: formDataWithFile,
        options: dio_pkg.Options(
          validateStatus: (status) => true,
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      final responseData = jsonDecode(response.data);
      if (response.statusCode == 200) {
        return responseData;
      } else {
        return responseData;
      }
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> sendSecondImage(
      Map<String, dynamic> formData, String imagePath) async {
    dio_pkg.Dio dio = dio_pkg.Dio();
    final url = '$baseUrl/reports/secondImage';

    try {
      dio_pkg.FormData formDataWithFile = dio_pkg.FormData.fromMap({
        'dto': dio_pkg.MultipartFile.fromString(
          jsonEncode(formData['dto']),
          contentType: dio_pkg.DioMediaType.parse('application/json'),
        ),
        'file': await dio_pkg.MultipartFile.fromFile(imagePath)
      });
      dio_pkg.Response response = await dio.post(
        url,
        data: formDataWithFile,
        options: dio_pkg.Options(
          validateStatus: (status) => true,
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      final responseData = jsonDecode(response.data);
      if (response.statusCode == 200) {
        return responseData;
      } else {
        return responseData;
      }
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> findReports(Map<String, dynamic> formData) async {
    final url = Uri.parse('$baseUrl/reports');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'startDate': formData["startDate"],
          'endDate': formData["endDate"],
          'state': formData["state"]
        },
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
}
