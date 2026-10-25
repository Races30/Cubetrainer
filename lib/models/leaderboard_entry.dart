import 'package:hive/hive.dart';

part 'leaderboard_entry.g.dart';

@HiveType(typeId: 6)
class LeaderboardEntry {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String cube; // e.g., "3x3"

  @HiveField(3)
  final String mode; // e.g., "cross", "f2l", "full"

  @HiveField(4)
  final int timeMs;

  @HiveField(5)
  final String? sessionId;

  @HiveField(6)
  final DateTime date;

  LeaderboardEntry({
    required this.id,
    this.userName = 'Local',
    this.cube = '3x3',
    required this.mode,
    required this.timeMs,
    this.sessionId,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'cube': cube,
      'mode': mode,
      'timeMs': timeMs,
      'sessionId': sessionId,
      'date': date.toIso8601String(),
    };
  }
}
