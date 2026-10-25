import 'package:hive/hive.dart';

part 'oll_pll_solve.g.dart';

@HiveType(typeId: 9)
class OllPllSolve extends HiveObject {
  @HiveField(0)
  final String caseId;

  @HiveField(1)
  final int timeMs;

  @HiveField(2)
  final DateTime date;

  OllPllSolve({
    required this.caseId,
    required this.timeMs,
    required this.date,
  });
}
