import 'package:hive/hive.dart';

part 'solve.g.dart';

@HiveType(typeId: 1)
enum CubeType {
  @HiveField(0)
  threeByThree,
  @HiveField(1)
  twoByTwo,
  @HiveField(2)
  fourByFour,
  @HiveField(3)
  fiveByFive,
  @HiveField(4)
  sixBySix,
  @HiveField(5)
  sevenBySeven,
  @HiveField(6)
  megaminx,
  @HiveField(7)
  pyraminx,
}

extension CubeTypeExtension on CubeType {
  String get label {
    switch (this) {
      case CubeType.threeByThree:
        return '3x3';
      case CubeType.twoByTwo:
        return '2x2';
      case CubeType.fourByFour:
        return '4x4';
      case CubeType.fiveByFive:
        return '5x5';
      case CubeType.sixBySix:
        return '6x6';
      case CubeType.sevenBySeven:
        return '7x7';
      case CubeType.megaminx:
        return 'Megaminx';
      case CubeType.pyraminx:
        return 'Pyraminx';
    }
  }

  static CubeType fromString(String s) {
    return CubeType.values.firstWhere((e) => e.toString().split('.').last == s,
        orElse: () => CubeType.threeByThree);
  }
}

@HiveType(typeId: 0)
class Solve {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String cube;
  @HiveField(2)
  final String scramble;
  @HiveField(3)
  final int timeMs;
  @HiveField(4)
  final String penalty; // '', '+2', 'DNF'
  @HiveField(5)
  final DateTime date;
  @HiveField(6)
  final CubeType? cubeType;
  @HiveField(7, defaultValue: 'main')
  final String sessionId;
  @HiveField(8)
  final Map<String, int>? splits;

  Solve({
    required this.id,
    required this.cube,
    required this.scramble,
    required this.timeMs,
    required this.penalty,
    required this.date,
    this.cubeType,
    this.sessionId = 'main',
    this.splits,
  });

  int effectiveTimeMs() {
    if (penalty == 'DNF') return 1 << 30; // large number
    if (penalty == '+2') return timeMs + 2000;
    return timeMs;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cube': cube,
      'scramble': scramble,
      'timeMs': timeMs,
      'penalty': penalty,
      'date': date.toIso8601String(),
      'cubeType': cubeType?.toString().split('.').last,
      'sessionId': sessionId,
      'splits': splits,
    };
  }

  factory Solve.fromMap(Map<String, dynamic> m) {
    return Solve(
      id: m['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      cube: m['cube'] ?? '3x3',
      scramble: m['scramble'] ?? '',
      timeMs: (m['timeMs'] is int)
          ? m['timeMs']
          : int.parse(m['timeMs'].toString()),
      penalty: m['penalty'] ?? '',
      date: DateTime.parse(m['date']),
      cubeType: CubeType.values.firstWhere(
          (e) =>
              e.toString().split('.').last ==
              (m['cubeType'] ??
                  CubeType.threeByThree.toString().split('.').last),
          orElse: () => CubeType.threeByThree),
      sessionId: m['sessionId'] ?? 'main',
      splits: m['splits'] != null ? Map<String, int>.from(m['splits']) : null,
    );
  }
}
