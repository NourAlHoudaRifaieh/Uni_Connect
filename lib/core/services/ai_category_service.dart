import 'dart:convert';

import 'package:http/http.dart' as http;

/// Talks to the Python + Gemini backend that assigns a category to a post.
///
/// Posts are composed of a description only (no title), so the backend reads
/// the description and returns one of [categories].
///
/// If the backend can't be reached (it isn't running yet, no connection, a
/// demo on a school network, ...) we fall back to a local keyword heuristic so
/// publishing never fails.
class AiCategoryService {
  /// Base URL of the Python backend.
  /// - Android emulator reaches the host machine at 10.0.2.2
  /// - Override per run/build with:
  ///   flutter run --dart-define=AI_BACKEND_URL=http://192.168.1.20:8000
  static const String baseUrl = String.fromEnvironment(
    'AI_BACKEND_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const List<String> categories = [
    'Exam',
    'Assignment',
    'Question',
    'Summary',
    'Announcement',
    'General',
  ];

  /// Returns just the category for [description].
  Future<String> categorize(String description) async {
    return (await categorizeDetailed(description)).category;
  }

  /// Returns the category AND who produced it ('gemini' = real LLM,
  /// 'fallback' = local keywords) plus the Gemini model name.
  Future<AiCategoryResult> categorizeDetailed(String description) async {
    final text = description.trim();
    if (text.isEmpty) {
      return AiCategoryResult('General', 'fallback', null);
    }

    try {
      final res = await http
          .post(
        Uri.parse('$baseUrl/categorize'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'description': text}),
      )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final category = (data['category'] ?? '').toString().trim();
        if (category.isNotEmpty) {
          return AiCategoryResult(
            _normalize(category),
            (data['source'] ?? 'gemini').toString(),
            data['model']?.toString(),
          );
        }
      }
    } catch (_) {
      // Backend offline / unreachable -> use the local fallback below.
    }
    return AiCategoryResult(_fallback(text), 'fallback', null);
  }

  /// Maps whatever the model replied to one of our fixed categories.
  String _normalize(String raw) {
    final lower = raw.toLowerCase();
    for (final c in categories) {
      if (c.toLowerCase() == lower) return c;
    }
    for (final c in categories) {
      if (lower.contains(c.toLowerCase())) return c;
    }
    return 'General';
  }

  /// Offline keyword heuristic used when the backend can't be reached.
  String _fallback(String text) {
    final t = text.toLowerCase();
    bool has(List<String> keys) => keys.any(t.contains);

    if (has(['exam', 'midterm', 'final', 'quiz'])) {
      return 'Exam';
    }
    if (has(['assignment', 'homework', 'due', 'submit', 'deadline'])) {
      return 'Assignment';
    }
    if (has(['summary', 'summarize', 'notes'])) {
      return 'Summary';
    }
    if (has(['announce', 'announcement', 'reminder'])) {
      return 'Announcement';
    }
    if (t.contains('?')) return 'Question';
    return 'General';
  }
}


class AiCategoryResult {
  final String category;
  final String source; // 'gemini' or 'fallback'
  final String? model;
  AiCategoryResult(this.category, this.source, this.model);

  bool get usedLlm => source == 'gemini';

  String get label => usedLlm
      ? 'Categorized by Gemini${model != null ? ' ($model)' : ''}: $category'
      : 'AI server unreachable - keyword fallback used: $category';
}
