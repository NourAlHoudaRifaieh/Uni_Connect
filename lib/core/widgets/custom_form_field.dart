import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormField extends StatelessWidget {

  final String? label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final Color? color;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final int? maxLines;

  const CustomFormField({
    super.key,
    this.label,
    required this.hint,
    required this.controller,
    this.color,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.maxLines,

  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label !=null)
          Text(
            label!,
            style: GoogleFonts.inter(
              fontSize:16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2F3A4A),
            ),
          ),
        const SizedBox(height:6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: obscureText ? 1: maxLines,
          style: GoogleFonts.inter(
            fontSize:16,
            color: Color(0xFF2F3A4A),
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize:15,
              color: Color(0xFFB5B5C3),
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical:8,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Color(0xFFE6E8EC),
                width:1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.blue,
                width:1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width:1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}
