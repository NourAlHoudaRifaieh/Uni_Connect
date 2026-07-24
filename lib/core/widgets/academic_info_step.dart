import 'package:flutter/material.dart';


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
          const Text(
            'Academic Information',
            style: TextStyle(
              fontSize:16,
              fontWeight:FontWeight.bold
            ),
          ),
          const SizedBox(height:6),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal:12),
            child:DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text(' Select your faculty'),
                value: selectedFaculty,
                items: kFaculties
                  .map( (f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
                onChanged: onFacultyChanged,
              ),
            ),
          ),
          const SizedBox(height:20),
          const Text(
            'Academic Year',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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
                    color: selected ? const Color(0xFF2563EB) : Colors.white,
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF2563EB)
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(10),
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
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Auto-assigned group',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$selectedFaculty · $selectedYear',
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 13,
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
                  child: OutlinedButton(
                    onPressed: onBack,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                    (hasGroup && !isLoading) ? onCreateAccount : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
