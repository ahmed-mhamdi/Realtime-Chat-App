import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final RegExp validationRegEx;
  final String hintText;
  final double height;
  final bool obscuredText;
  final void Function(String?) onSaved;
  const CustomFormField(
      {super.key,
      required this.hintText,
      required this.height,
      required this.validationRegEx,
      this.obscuredText = false,
      required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        obscureText: obscuredText,
        onSaved: onSaved,
        validator: (value) {
          if (value != null && validationRegEx.hasMatch(value)) {
            return null;
          }
          return "Please entre a valid ${hintText.toLowerCase()}";
        },
        decoration: InputDecoration(
            hintText: hintText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
