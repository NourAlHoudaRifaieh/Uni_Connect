/// Year helpers used by the feed and the subject screens.
int? yearNumber(String? year) {
  if (year == null) return null;
  return int.tryParse(year.replaceAll(RegExp(r'[^0-9]'), ''));
}

/// Years 4 and 5 may never hold subjects from another year.
bool isLockedYear(String? year) {
  final n = yearNumber(year);
  return n == 4 || n == 5;
}