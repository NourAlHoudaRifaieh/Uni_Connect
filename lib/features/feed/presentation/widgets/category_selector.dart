import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width:1.5),
          bottom: BorderSide(color: Color(0xFFF1F5F9), width:1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset:Offset(0,8),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical:12),
      child:SizedBox(
        height:32,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal:20),
          itemCount: categories.length,
          itemBuilder: (context, index){
            String category = categories[index];
            bool isSelected = category == selectedCategory;
            return Padding(
              padding: EdgeInsets.only(right:8),
              child: InkWell(
                onTap: () => onCategorySelected(category),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal:18),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(0xFF1D61FF)
                        : Color(0xFFE6E8EC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.inter(
                      color: isSelected ? Colors.white : Color(0xFF475569),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 13
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}