import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

class KakaoAddressScreen extends StatelessWidget {
  KakaoAddressScreen({super.key});

  /// Form State
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> formData = {};

  /// Controller
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailController =
      TextEditingController();

  Widget _gap() {
    return const SizedBox(
      height: 10,
    );
  }

  void _searchAddress(BuildContext context) async {
    try {
      print(111);
      // 화면 전환 중 비동기 처리가 올바르게 동작하는지 확인
      KopoModel? model = await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => RemediKopo(),
        ),
      );
      if (model != null) {
        final postcode = model.zonecode ?? '';
        _postcodeController.value = TextEditingValue(
          text: postcode,
        );
        formData['postcode'] = postcode;

        final address = model.address ?? '';
        _addressController.value = TextEditingValue(
          text: address,
        );
        formData['address'] = address;

        final buildingName = model.buildingName ?? '';
        _addressDetailController.value = TextEditingValue(
          text: buildingName,
        );
        formData['address_detail'] = buildingName;
      }
    } catch (e) {
      // 예외 발생 시 처리할 내용
      print("주소 검색 중 에러 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('주소 검색 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kakao 주소검색 API'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _postcodeController,
                    decoration: const InputDecoration(
                      hintText: '우편번호',
                    ),
                    readOnly: true,
                  ),
                  _gap(),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      hintText: '기본주소',
                    ),
                    readOnly: true,
                  ),
                  _gap(),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: _addressDetailController,
                    decoration: const InputDecoration(
                      hintText: '상세주소 입력',
                    ),
                  ),
                  _gap(),
                  CupertinoButton(
                    onPressed: () => _searchAddress(context),
                    child: const Text('주소검색'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
