import 'package:flutter/material.dart';
import 'package:frontend/components/common/button.dart';
import 'package:frontend/components/common/input.dart';
import 'package:frontend/components/common/input_label.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/services/api_service.dart';
import 'package:get/get.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final MainController controller = Get.put(MainController());
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController addressDetailController = TextEditingController();

  void searchAddress(BuildContext context) async {
    KopoModel? model = await Get.to(() => RemediKopo());

    if (model != null) {
      final postcode = model.zonecode ?? '';
      zipCodeController.text = postcode;
      formData['zip_code'] = postcode;

      final address = model.address ?? '';
      addressController.text = address;
      formData['address'] = address;

      final buildingName = model.buildingName ?? '';
      addressDetailController.text = buildingName;
      formData['address_detail'] = buildingName;
    }
  }

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final apiService = ApiService();
      formData['address'] = {
        'address': formData.remove('address') ?? '',
        'addressDetail': formData.remove('address_detail') ?? '',
        'zipCode': formData.remove('zip_code') ?? ''
      };
      try {
        await apiService.signUp(formData);
        Get.to(() => const LoginScreen());
      } catch (e) {
        Get.snackbar('오류', '회원가입 중 오류가 발생했습니다.',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  String? validatePassword(String? value) {
    if (value != passwordController.text) {
      return "비밀번호가 일치하지 않습니다.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 350,
                ),
              ),
              const SizedBox(height: 50),
              const InputLabel(name: "이메일"),
              Input(
                controller: emailController,
                inputType: TextInputType.emailAddress,
                buttonText: "중복 확인",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "이메일을 입력하세요.";
                  }
                  if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                      .hasMatch(value)) {
                    return "유효한 이메일 주소를 입력하세요.";
                  }
                  if (formData["email"] == null || value != formData["email"]) {
                    return "이메일 중복을 확인해주세요.";
                  }
                  return null;
                },
                onPressed: () async {
                  final apiService = ApiService();
                  try {
                    final res =
                        apiService.emailCheck({'email': formData['email']});
                    if (res == true) {
                      formData["email"] = emailController.value;
                    }
                  } catch (e) {
                    Get.snackbar('오류', '중복 확인 중 오류가 발생했습니다.',
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),
              const InputLabel(name: "비밀번호"),
              Input(
                controller: passwordController,
                inputType: TextInputType.visiblePassword,
                obscure: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "비밀번호는 6자 이상이어야 합니다.";
                  }
                  return null;
                },
                onSaved: (value) {
                  formData['password'] = value ?? '';
                },
              ),
              const InputLabel(name: "비밀번호 확인"),
              Input(
                controller: confirmPasswordController,
                inputType: TextInputType.visiblePassword,
                obscure: true,
                validator: validatePassword,
              ),
              const InputLabel(name: "이름"),
              Input(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "이름을 입력하세요.";
                  }
                  return null;
                },
                onSaved: (value) {
                  formData['name'] = value ?? '';
                },
              ),
              const InputLabel(name: "휴대전화 번호"),
              Input(
                controller: phoneController,
                inputType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "전화번호를 입력하세요.";
                  }
                  return null;
                },
                onSaved: (value) {
                  formData['tel'] = value ?? '';
                },
              ),
              const InputLabel(name: "주소"),
              Input(
                controller: addressController,
                onTap: () => searchAddress(context),
                readonly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "주소를 입력하세요.";
                  }
                  return null;
                },
                onSaved: (value) {
                  formData['address'] = value ?? '';
                },
              ),
              Input(
                controller: addressDetailController,
                onSaved: (value) {
                  formData['address_detail'] = value ?? '';
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Button(
                  text: "회원가입",
                  onPressed: submitForm,
                  horizontal: 95,
                  vertical: 10,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
