import 'package:flutter/material.dart';
import 'package:uni_connect/core/widgets/custom_dropdown.dart';
import 'package:uni_connect/core/widgets/custom_elevated_button.dart';
import 'package:google_fonts/google_fonts.dart';

// const List<String> kFaculties = [
//   'Business Administration',
//   'Computer Science',
//   'Engineering',
//   'Law',
//   'Medicine',
// ];

const List<String> kBusinessMajors = [
  'Business Computer',
  'Accounting and Auditing',
  'Finance and Financial Establishments',
  'Management',
  'Marketing',
];

const List<String> kAcademicYears = [
  'Year 1',
  'Year 2',
  'Year 3',
  'Year 4',
  'Year 5',
];

const List<String> kDepartments = [
  'Business Administration',
  'Economic Science',
];

class AcademicInfoStep extends StatelessWidget {
  // final String? selectedFaculty;
  final String? selectedYear;
  final bool isLoading;
  // final ValueChanged<String?> onFacultyChanged;
  final ValueChanged<String> onYearChanged;
  final VoidCallback onBack;
  final VoidCallback onCreateAccount;
  final String? selectedMajor;
  final ValueChanged<String?> onMajorChanged;
  final String? selectedDepartment;
  final ValueChanged<String?> onDepartmentChanged;

  const AcademicInfoStep({
    super.key,
    required this.isLoading,
    required this.onBack,
    required this.onCreateAccount,
    // required this.onFacultyChanged,
    required this.onYearChanged,
    // required this.selectedFaculty,
    required this.selectedYear,
    required this.selectedMajor,
    required this.onMajorChanged,
    required this.selectedDepartment,
    required this.onDepartmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    // final bool hasGroup = selectedFaculty != null && selectedYear != null && selectedMajor !=null;

    bool isBusiness = selectedDepartment == 'Business Administration';
    bool needsMajor = isBusiness && selectedYear != null && selectedYear != 'Year 1';
    bool hasValidMajor = !needsMajor || (selectedMajor != null);

    final bool canProceed = selectedDepartment != null && selectedYear != null && hasValidMajor;

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
            'Department / Program',
            style: GoogleFonts.inter(
              fontSize:14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2F3A4A),
            ),
          ),
          const SizedBox(height: 8),
          CustomDropdown(
              value: selectedDepartment,
              hint: 'Select your department',
              items: kDepartments,
              onChanged: onDepartmentChanged,
          ),
          // SizedBox(height:20),
          // Text(
          //   'Major',
          //   style: GoogleFonts.inter(
          //     fontSize:14,
          //     fontWeight: FontWeight.w600,
          //     color: Color(0xFF2F3A4A),
          //   ),
          // ),
          // const SizedBox(height: 8),
          // CustomDropdown(
          //   value: selectedMajor,
          //   hint: 'Select your major',
          //   items: kMajors,
          //   onChanged: onMajorChanged,
          // ),+
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

          if(isBusiness && selectedYear != null && selectedYear != 'Year 1') ...[
            const SizedBox(height: 20),
            Text(
              'Major',
              style: GoogleFonts.inter(
                fontSize:14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F3A4A),
              ),
            ),
            const SizedBox(height: 8),
            CustomDropdown(
              value: selectedMajor,
              hint: 'Select your major',
              items: kBusinessMajors,
              onChanged: onMajorChanged,
            ),
          ],
          const SizedBox(height: 20),
          if (canProceed)
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
                    (isBusiness && selectedYear != 'Year 1' && selectedMajor != null && selectedMajor!.isNotEmpty)
                        ? 'Faculty of Economics & Business Administration · $selectedMajor · $selectedYear'
                        : 'Faculty of Economics & Business Administration · $selectedYear',
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
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: CustomElevatedButton(
                      text: 'Create Account',
                      onPressed: (canProceed && !isLoading) ? onCreateAccount : null,
                      isLoading: isLoading,
                  ),
                ),
              ),
            ],
          ),
          SizedBox( height:30),
        ],
      ),
    );
  }
}
