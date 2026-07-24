import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final Color? color;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.color,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize:13,
          ),
        ),
        const SizedBox(height:6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
