import 'solve.dart';

class OllPllCase {
  final String id;
  final String name;
  final String category;
  final String group;
  final String algorithm;
  final List<List<int>> uFaceGrid;
  final List<int> edgeBand;
  final CubeType puzzle;
  final String? note;

  const OllPllCase({
    required this.id,
    required this.name,
    required this.category,
    required this.group,
    required this.algorithm,
    required this.uFaceGrid,
    required this.edgeBand,
    required this.puzzle,
    this.note,
  });
}
