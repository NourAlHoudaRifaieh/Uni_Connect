import 'package:flutter/material.dart';
import 'package:uni_connect/core/widgets/custom_dropdown.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:google_fonts/google_fonts.dart';

const List<String> kFaculties = [
  'Business Administration',
  'Computer Science',
  'Engineering',
  'Law',
  'Medicine',
];

const List<String> kAcademicYears = [
  'Year 1',
  'Year 2',
  'Year 3',
  'Master 1',
  'Master 2',
];

class AcademicInfoStep extends StatelessWidget {
  final String? selectedFaculty;
  final String? selectedYear;
  final bool isLoading;
  final ValueChanged<String?> onFacultyChanged;
  final ValueChanged<String> onYearChanged;
  final VoidCallback onBack;
  final VoidCallback onCreateAccount;

  const AcademicInfoStep({
    super.key,
    required this.isLoading,
    required this.onBack,
    required this.onCreateAccount,
    required this.onFacultyChanged,
    required this.onYearChanged,
    required this.selectedFaculty,
    required this.selectedYear,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasGroup = selectedFaculty != null && selectedYear != null;
    // TODO: implement build
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Text(
            'Academic Information',
            style: GoogleFonts.inter(
              fontSize:16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height:20),
          Text(
            'Faculty',
            style: GoogleFonts.inter(
              fontSize:14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2F3A4A),
            ),
          ),
          const SizedBox(height: 8),
          CustomDropdown(
              value: selectedFaculty,
              hint: 'Select your faculty',
              items: kFaculties,
              onChanged: onFacultyChanged,
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     color: Color(0xFFF3F4F6),
          //     borderRadius: BorderRadius.circular(16),
          //     border: Border.all(
          //       color: Color(0xFFE2E8F0),
          //       width:1,
          //     ),
          //   ),
          //   // padding: const EdgeInsets.symmetric(horizontal:12),
          //   child:DropdownButtonHideUnderline(
          //     child: DropdownButton<String>(
          //       isExpanded: true,
          //       hint:  Text(' Select your faculty',
          //         style: GoogleFonts.inter(
          //           fontSize:13,
          //           color: Color(0xFFB5B5C3),
          //           // fontWeight: FontWeight.w400,
          //         ),
          //       ),
          //       icon: Icon(Icons.keyboard_arrow_down_rounded,
          //         color: Color(0xFF94A3B8), size:12,
          //       ),
          //       value: selectedFaculty,
          //       dropdownColor: Colors.white,
          //       style: GoogleFonts.inter(
          //         color: Color(0xFF1E293B),
          //         fontSize:14,
          //         fontWeight: FontWeight.w500,
          //       ),
          //       items: kFaculties
          //         .map( (f) => DropdownMenuItem(value: f, child: Text(f)))
          //         .toList(),
          //       onChanged: onFacultyChanged,
          //     ),
          //   ),
          // ),
          const SizedBox(height:20),
          Text(
            'Academic Year',
            style: GoogleFonts.inter(
              fontSize:14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2F3A4A),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: kAcademicYears.map((year) {
              final bool selected = selectedYear == year;
              return GestureDetector(
                onTap: () => onYearChanged(year),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 24 * 2 - 10) / 2,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  // decoration: BoxDecoration(
                  //   color: Color(0xFFF3F4F6),
                  //   borderRadius: BorderRadius.circular(20),
                  //   border: Border.all(
                  //     color: Color(0xFFE2E8F0),
                  //     width:1,
                  //   ),
                  decoration: BoxDecoration(
                    color: selected ?  Color(0xFF2563EB) : Color(0xFFF3F4F6),
                    border: Border.all(
                      color: selected
                          ?  Color(0xFFE2E8F0)
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    year,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          if (hasGroup)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:  Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFF2563EB),
                  width:1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto-assigned group',
                    style: GoogleFonts.inter(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$selectedFaculty · $selectedYear',
                    style: GoogleFonts.inter(
                      color: Color(0xFF2563EB),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: CustomElevatedButton(
                      text: 'Back',
                      onPressed: onBack,
                      type: ButtonType.outlined,
                  ),
                  // child: OutlinedButton(
                  //   onPressed: onBack,
                  //   style: OutlinedButton.styleFrom(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(25),
                  //     ),
                  //   ),
                  //   child: const Text('Back'),
                  // ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: CustomElevatedButton(
                      text: 'Create Account',
                      onPressed: (hasGroup && !isLoading) ? onCreateAccount : null,
                      isLoading: isLoading,
                  ),
                  // child: ElevatedButton(
                  //   onPressed:
                  //   (hasGroup && !isLoading) ? onCreateAccount : null,
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color(0xFF2563EB),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(25),
                  //     ),
                  //   ),
                  //   child: isLoading
                  //       ? const CircularProgressIndicator(color: Colors.white)
                  //       : const Text(
                  //     'Create Account',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
