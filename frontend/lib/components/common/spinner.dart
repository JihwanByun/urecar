import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color: Colors.blue, // You can customize the color here
        size: 50.0, // Customize the size if needed
      ),
    );
  }
}
