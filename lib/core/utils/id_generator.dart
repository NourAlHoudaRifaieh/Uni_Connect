library;

// Finds and returns the highest numeric suffix for the given prefix among existing IDs.
int maxNumericSuffix(Iterable<String> ids, String prefix) {
  int maxId = 0;
  for (final id in ids) {
    if (id.startsWith(prefix)) {
      final n = int.tryParse(id.substring(prefix.length)) ?? 0;
      if (n > maxId) maxId = n;
    }
  }
  return maxId;
}

// Generates the next sequential ID by incrementing the highest existing number by one.
String nextSequentialId(Iterable<String> ids, String prefix) =>
    '$prefix${maxNumericSuffix(ids, prefix) + 1}';