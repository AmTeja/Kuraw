import 'package:flutter/material.dart';
import 'package:kuraw/core/util/context_extensions.dart';

class RTextField extends StatelessWidget {
  const RTextField({
    super.key,
    this.onChanged,
    this.controller,
    this.decoration,
    this.initialValue,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.errorText,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.counterText,
  });

  final Function(String)? onChanged;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final String? initialValue;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final String? counterText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.rWidth,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        minLines: minLines,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: decoration ??
            InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              labelText: labelText,
              errorText: errorText,
              hintText: hintText,
              counterText: counterText,
            ),
      ),
    );
  }
}
