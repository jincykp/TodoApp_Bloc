import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class TextformFields extends StatelessWidget {
  TextEditingController controller;
  String? hintText;
  String? labelText;
  String? Function(String?)? validator;
  Widget? prefixIcon;
  final int? minLines;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;

  TextformFields(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.labelText,
      required this.validator,
      this.prefixIcon,
      this.inputFormatters,
      this.maxLines,
      this.minLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: hintText,
        labelText: labelText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 90, 87, 87)),
        prefixIcon: prefixIcon,
      ),
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }
}
