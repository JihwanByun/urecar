import 'package:flutter/material.dart';
import 'package:frontend/components/common/button.dart';
import 'package:frontend/components/common/input.dart';
import 'package:frontend/components/common/input_label.dart';
import 'package:frontend/screens/adress_screen.dart';
import 'package:get/get.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  Map<String, String> formData = {};
  final TextEditingController emailController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController addressDetailController = TextEditingController();

  void searchAddress(BuildContext context) async {
    KopoModel? model = await Get.to(() => RemediKopo());

    if (model != null) {
      final postcode = model.zonecode ?? '';
      zipCodeController.value = TextEditingValue(
        text: postcode,
      );
      formData['postcode'] = postcode;

      final address = model.address ?? '';
      addressController.value = TextEditingValue(
        text: address,
      );
      formData['address'] = address;

      final buildingName = model.buildingName ?? '';
      addressDetailController.value = TextEditingValue(
        text: buildingName,
      );
      formData['address_detail'] = buildingName;
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
              const SizedBox(
                height: 150,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 350,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const InputLabel(name: "이메일"),
              Input(
                inputType: TextInputType.emailAddress,
                buttonText: "중복 확인",
                onPressed: () async {
                  print(1);
                },
              ),
              const InputLabel(name: "비밀번호"),
              const Input(
                inputType: TextInputType.visiblePassword,
                obscure: true,
              ),
              const InputLabel(name: "비밀번호 확인"),
              const Input(
                inputType: TextInputType.visiblePassword,
                obscure: true,
              ),
              const InputLabel(name: "이름"),
              const Input(),
              const InputLabel(name: "휴대전화 번호"),
              const Input(
                inputType: TextInputType.phone,
              ),
              const InputLabel(name: "주소"),
              Input(
                  controller: addressController,
                  onTap: () => searchAddress(context)),
              Input(
                controller: addressDetailController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Button(
                    text: "회원가입",
                    onPressed: () {},
                    horizontal: 95,
                    vertical: 10,
                    fontSize: 15),
              )
            ],
          ),
        ),
      ),
    );
  }
}
