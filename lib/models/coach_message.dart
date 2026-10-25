import 'package:hive/hive.dart';

part 'coach_message.g.dart';

@HiveType(typeId: 7)
class CoachMessage {
  @HiveField(0)
  final String role; // 'user' or 'system'
  @HiveField(1)
  final String content;
  @HiveField(2)
  final DateTime date;

  CoachMessage({
    required this.role,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'content': content,
      'date': date.toIso8601String(),
    };
  }

  factory CoachMessage.fromMap(Map<String, dynamic> m) {
    return CoachMessage(
      role: m['role'] ?? 'system',
      content: m['content'] ?? '',
      date: DateTime.parse(m['date']),
    );
  }
}
