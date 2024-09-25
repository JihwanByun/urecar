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

  String? emailError;
  String? emailSuccess;
  String? passwordError;
  String? confirmPasswordError;
  String? nameError;
  String? phoneError;
  String? addressError;

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

  Future<void> checkEmailDuplicate() async {
    final apiService = ApiService();
    setState(() {
      emailError = null;
      emailSuccess = null;
    });

    try {
      final isAvailable =
          await apiService.emailCheck({'email': emailController.text});

      if (!isAvailable) {
        setState(() {
          emailSuccess = "사용 가능한 이메일입니다.";
          emailError = null;
          formData["email"] = emailController.text;
        });
      } else {
        setState(() {
          emailError = "이미 사용 중인 이메일입니다.";
          emailSuccess = null;
        });
      }
    } catch (e) {
      setState(() {
        emailError = "이메일 중복 확인 중 오류가 발생했습니다.";
        emailSuccess = null;
      });
    }
  }

  void submitForm() async {
    setState(() {
      // 에러 메시지 초기화
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
      nameError = null;
      phoneError = null;
      addressError = null;
    });

    bool isValid = true;

    // 유효성 검사: 각 필드마다 조건을 확인하여 에러 메시지 설정
    if (emailController.text.isEmpty) {
      setState(() {
        emailError = "이메일을 입력하세요.";
      });
      isValid = false;
    } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
        .hasMatch(emailController.text)) {
      setState(() {
        emailError = "유효한 이메일 주소를 입력하세요.";
      });
      isValid = false;
    } else if (emailSuccess == null) {
      setState(() {
        emailError = "이메일 중복을 확인해주세요."; // 중복 확인 필요
      });
      isValid = false;
    }

    if (passwordController.text.length < 6) {
      setState(() {
        passwordError = "비밀번호는 6자 이상이어야 합니다.";
      });
      isValid = false;
    }

    if (confirmPasswordController.text != passwordController.text) {
      setState(() {
        confirmPasswordError = "비밀번호가 일치하지 않습니다.";
      });
      isValid = false;
    }

    if (nameController.text.isEmpty) {
      setState(() {
        nameError = "이름을 입력하세요.";
      });
      isValid = false;
    }

    if (phoneController.text.isEmpty) {
      setState(() {
        phoneError = "전화번호를 입력하세요.";
      });
      isValid = false;
    }

    if (addressController.text.isEmpty) {
      setState(() {
        addressError = "주소를 입력하세요.";
      });
      isValid = false;
    }

    if (isValid) {
      formKey.currentState!.save();
      final apiService = ApiService();
      formData['address'] = {
        'address': formData.remove('address') ?? '',
        'addressDetail': formData.remove('address_detail') ?? '',
        'zipCode': formData.remove('zip_code') ?? ''
      };
      try {
        await apiService.signUp(formData);
        Get.offAllNamed('/login');
      } catch (e) {
        Get.snackbar('오류', '회원가입 중 오류가 발생했습니다.',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
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
                onPressed: checkEmailDuplicate,
              ),
              if (emailError != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                  child: Text(
                    emailError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (emailSuccess != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                  child: Text(
                    emailSuccess!,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              const InputLabel(name: "비밀번호"),
              Input(
                controller: passwordController,
                inputType: TextInputType.visiblePassword,
                obscure: true,
                onSaved: (value) {
                  formData['password'] = value ?? '';
                },
              ),
              if (passwordError != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                  child: Text(
                    passwordError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const InputLabel(name: "비밀번호 확인"),
              Input(
                controller: confirmPasswordController,
                inputType: TextInputType.visiblePassword,
                obscure: true,
              ),
              if (confirmPasswordError != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                  child: Text(
                    confirmPasswordError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const InputLabel(name: "이름"),
              Input(
                controller: nameController,
                onSaved: (value) {
                  formData['name'] = value ?? '';
                },
              ),
              if (nameError != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                  child: Text(
                    nameError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const InputLabel(name: "휴대전화 번호"),
              Input(
                controller: phoneController,
                inputType: TextInputType.phone,
                onSaved: (value) {
                  formData['tel'] = value ?? '';
                },
              ),
              if (phoneError != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                  child: Text(
                    phoneError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const InputLabel(name: "주소"),
              Input(
                controller: addressController,
                onTap: () => searchAddress(context),
                readonly: true,
              ),
              if (addressError != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                  child: Text(
                    addressError!,
                    style: const TextStyle(color: Colors.red),
                  ),
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
