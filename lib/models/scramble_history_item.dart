import 'package:hive/hive.dart';
import 'solve.dart';

part 'scramble_history_item.g.dart';

@HiveType(typeId: 3)
class ScrambleHistoryItem {
  @HiveField(0)
  final String scramble;
  @HiveField(1)
  final CubeType cubeType;
  @HiveField(2)
  final DateTime date;

  ScrambleHistoryItem({
    required this.scramble,
    required this.cubeType,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'scramble': scramble,
      'cubeType': cubeType.toString().split('.').last,
      'date': date.toIso8601String(),
    };
  }

  factory ScrambleHistoryItem.fromMap(Map<String, dynamic> m) {
    return ScrambleHistoryItem(
      scramble: m['scramble'] ?? '',
      cubeType: CubeType.values.firstWhere(
        (e) => e.toString().split('.').last == m['cubeType'],
        orElse: () => CubeType.threeByThree,
      ),
      date: DateTime.parse(m['date']),
    );
  }
}
