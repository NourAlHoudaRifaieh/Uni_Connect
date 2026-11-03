import 'dart:convert';

import 'package:http/http.dart' as http;

/// Talks to the Python backend that assigns a category to a post using our own
/// trained model (TF-IDF + sentence embeddings, no external LLM).
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
    'Announcement',
    'General',
  ];

  /// Returns just the category for [description].
  Future<String> categorize(String description) async {
    return (await categorizeDetailed(description)).category;
  }

  /// Returns the category AND who produced it ('model' = our trained model,
  /// 'fallback' = local keywords) plus the model's confidence (0..1).
  Future<AiCategoryResult> categorizeDetailed(String description) async {
    final text = description.trim();
    if (text.isEmpty) {
      return AiCategoryResult('General', 'fallback', null, null);
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
            (data['source'] ?? 'model').toString(),
            data['model']?.toString(),
            (data['confidence'] as num?)?.toDouble(),
          );
        }
      }
    } catch (_) {
      // Backend offline / unreachable -> use the local fallback below.
    }
    return AiCategoryResult(_fallback(text), 'fallback', null, null);
  }

  /// Maps whatever the backend replied to one of our fixed categories.
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
    if (has(['announce', 'announcement', 'reminder', 'cancelled', 'canceled'])) {
      return 'Announcement';
    }
    if (t.contains('?')) return 'Question';
    return 'General';
  }
}


class AiCategoryResult {
  final String category;
  final String source; // 'model' or 'fallback'
  final String? model;
  final double? confidence; // 0..1, only when our model answered
  AiCategoryResult(this.category, this.source, this.model, this.confidence);

  bool get usedModel => source == 'model';

  String get label {
    if (!usedModel) {
      return 'AI server unreachable - keyword fallback used: $category';
    }
    final pct = confidence != null ? ' (${(confidence! * 100).round()}%)' : '';
    return 'Categorized by Uni-Connect model: $category$pct';
  }
}