import '../models/oll_pll_case.dart';
import '../models/solve.dart';

enum AlgorithmDifficulty { easy, medium, hard, unclassified }

class OllPllClassifier {
  static AlgorithmDifficulty classify(OllPllCase c) {
    if (c.puzzle != CubeType.threeByThree) {
      return AlgorithmDifficulty.unclassified;
    }

    if (c.category.toUpperCase().contains('OLL')) {
      return _classifyOll(c);
    } else if (c.category.toUpperCase().contains('PLL')) {
      return _classifyPll(c);
    }

    return AlgorithmDifficulty.unclassified;
  }

  static AlgorithmDifficulty _classifyOll(OllPllCase c) {
    final group = c.group.toLowerCase();

    // Easy: OCLL (Cross is solved)
    if (group.contains('ocll')) {
      return AlgorithmDifficulty.easy;
    }

    // Hard: Dot cases, Awkward cases
    if (group.contains('dot') || group.contains('awkward')) {
      return AlgorithmDifficulty.hard;
    }

    // Medium: Everything else (T, Square, Lightning, Fish, Knight, P, C, L, Line)
    return AlgorithmDifficulty.medium;
  }

  static AlgorithmDifficulty _classifyPll(OllPllCase c) {
    final name = c.name.toLowerCase();

    // Easy: Edges only (H, Z, Ua, Ub) and very common/ergonomic ones (T, Y, Jb)
    if (name.contains('h ') ||
        name.contains('z ') ||
        name.contains('u ') ||
        name.contains('ua') ||
        name.contains('ub') ||
        name.contains('t ') ||
        name.contains('y ') ||
        name.contains('jb')) {
      return AlgorithmDifficulty.easy;
    }

    // Hard: G perms, N perms, E, V
    if (name.contains('g ') ||
        name.contains('ga') ||
        name.contains('gb') ||
        name.contains('gc') ||
        name.contains('gd') ||
        name.contains('n ') ||
        name.contains('na') ||
        name.contains('nb') ||
        name.contains('e ') ||
        name.contains('v ')) {
      return AlgorithmDifficulty.hard;
    }

    // Medium: Aa, Ab, F, Ja, Ra, Rb
    return AlgorithmDifficulty.medium;
  }

  static List<String> getAlgSetsForPuzzle(CubeType puzzle) {
    switch (puzzle) {
      case CubeType.twoByTwo:
        return ['OLL', 'CLL'];
      case CubeType.threeByThree:
        return ['OLL', 'PLL'];
      case CubeType.fourByFour:
      case CubeType.sixBySix:
        return ['OLL Parity', 'PLL Parity'];
      case CubeType.fiveByFive:
      case CubeType.sevenBySeven:
        return ['PLL Parity'];
      case CubeType.pyraminx:
        return ['L4E'];
      case CubeType.megaminx:
        return ['EOLL', 'OCLL', 'EPLL', 'CPLL'];
// Removed default case
    }
  }

  static String getLabelForPuzzle(CubeType puzzle) {
    switch (puzzle) {
      case CubeType.twoByTwo:
        return 'OLL/CLL';
      case CubeType.threeByThree:
        return 'OLL/PLL';
      case CubeType.fourByFour:
      case CubeType.fiveByFive:
      case CubeType.sixBySix:
      case CubeType.sevenBySeven:
        return 'Parity';
      case CubeType.pyraminx:
        return 'L4E';
      case CubeType.megaminx:
        return 'LL';
    }
  }
}
