import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown extends StatelessWidget{
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical:3
      ),
        decoration: BoxDecoration(
          color: Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFFE2E8F0),
            width:1,
          ),
        ),
        child:DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            hint:  Text(' Select your faculty',
              style: GoogleFonts.inter(
                fontSize:14,
                color: Color(0xFFB5B5C3),
              ),
            ),
            icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF94A3B8), size:20,
            ),
            value: value,
            dropdownColor: Colors.white,
            style: GoogleFonts.inter(
              color: Color(0xFF1E293B),
              fontSize:14,
              fontWeight: FontWeight.w500,
            ),
            items: items.map((String item){
              return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),

    );
  }
}