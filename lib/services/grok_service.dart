import 'dart:convert';
import 'package:http/http.dart' as http;

/// Example Grok (OpenRouter) service.
/// Replace OPENROUTER_API_KEY with your key; do NOT hardcode in production.
class GrokService {
  final String apiKey;
  final String endpoint;
  final String title;

  GrokService({
    required this.apiKey,
    this.endpoint = 'https://openrouter.ai/api/v1/chat/completions',
    this.title = 'CubeTrainer',
  });

  Future<String> analyzeStats(Map<String, dynamic> stats) async {
    final messages = [
      {'role': 'system', 'content': 'Sei un coach esperto di Rubik\'s Cube. Fornisci analisi concise e pratiche.'},
      {'role': 'user', 'content': 'Analizza queste statistiche e suggerisci un piano di allenamento: ${jsonEncode(stats)}'},
    ];
    final body = jsonEncode({
      'model': 'deepseek/deepseek-chat-v3.1:free',
      'messages': messages,
      'max_tokens': 500,
    });

    final resp = await http.post(Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
        'X-Title': title,
      },
      body: body
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      if (data['choices'] != null && data['choices'].isNotEmpty) {
        return data['choices'][0]['message']['content'] ?? '';
      }
      return data.toString();
    } else {
      throw Exception('API error: \${resp.statusCode} - \${resp.body}');
    }
  }
}
