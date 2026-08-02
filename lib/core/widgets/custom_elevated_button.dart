import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ButtonType { elevated, outlined }

class CustomElevatedButton extends StatelessWidget{
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.type= ButtonType.elevated,
    this.backgroundColor = const Color(0xFF2563EB),
    this.textColor= Colors.white,
    this.height= 50.0,
    this.borderRadius= 20.0,
  });

  @override
  Widget build(BuildContext context){
    final isElevated = type == ButtonType.elevated;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: isElevated
        ? ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            elevation:5,
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _buildChild(context, textColor),
        )
        : OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side:BorderSide(color:backgroundColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _buildChild(context, backgroundColor),
          ),
    );
  }

  Widget _buildChild(BuildContext context, Color labelColor){
    if (isLoading){
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: type == ButtonType.elevated ? Colors.white :backgroundColor,
        ),
      );
    }

    return Text(
      text,
      style: GoogleFonts.inter(
        color: labelColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

}

