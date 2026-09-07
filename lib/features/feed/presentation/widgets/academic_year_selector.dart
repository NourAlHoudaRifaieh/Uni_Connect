import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final List<String> kAcademicYears = [
  'Year 1',
  'Year 2',
  'Year 3',
  'Year 4',
  'Year 5',
];

class AcademicYearSelector extends StatelessWidget {
  final List<String> years;
  final String selectedYear;
  final ValueChanged<String> onYearSelected;

  const AcademicYearSelector({
    super.key,
    this.years = const [
      'Year 1',
      'Year 2',
      'Year 3',
      'Year 4',
      'Year 5',
    ],
    required this.selectedYear,
    required this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: years.length,
        itemBuilder: (context, index) {
          final String year = years[index];
          final bool isSelected = year == selectedYear;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onYearSelected(year),
                borderRadius: BorderRadius.circular(24),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1D61FF)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1D61FF)
                          : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    year,
                    style: GoogleFonts.inter(
                      color: isSelected ? Colors.white : const Color(0xFF334155),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}