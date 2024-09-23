import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String? buttonText;
  final Future<void> Function()? onPressed;
  final TextInputType? inputType;
  final bool? obscure;
  final Function? onTap;
  final TextEditingController? controller;

  const Input({
    super.key,
    this.inputType,
    this.buttonText,
    this.onPressed,
    this.obscure,
    this.onTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 3,
        bottom: 7,
        right: 60,
        left: 60,
      ),
      child: TextFormField(
        controller: controller,
        onTap: onTap != null ? onTap as void Function() : null,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        keyboardType: inputType,
        obscureText: obscure ?? false,
        decoration: InputDecoration(
          suffixIcon: buttonText != null
              ? Padding(
                  padding: const EdgeInsets.only(
                    right: 7,
                    top: 3,
                    bottom: 3,
                  ),
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).primaryColor,
                        )),
                    child: Text(
                      buttonText!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black45),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
