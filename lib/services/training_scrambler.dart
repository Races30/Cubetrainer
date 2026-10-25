import 'dart:math';
import 'package:cubetrainer/models/solve.dart';
import 'package:cubetrainer/models/exercise_type.dart';
import 'scramble_generator.dart';
import 'cube_state.dart';

class TrainingScrambler {
  static final _random = Random();

  // Basic OLL cases (reverse algorithms to setup the case)
  static const _ollAlgorithms = [
    "R U2 R2 F R F' U2 R' F R F'", // OLL 1
    "F R U R' U' F'", // OLL 45
    "R U R' U R U2 R'", // Sune
    "R U2 R' U' R U' R'", // Anti-Sune
    "F U R U' R' F'", // OLL 44
    "R U2 R2 U' R2 U' R2 U2 R", // OLL 21 (Pi)
    "R2 D R' U2 R D' R' U2 R'", // Headlights
    "r U R' U' r' F R F'", // OLL 28
    "R U R' U' R' F R F'", // OLL 33
    "F R U R' U' R U R' U' F'", // OLL 47
    "R U2 R2 U' R2 U' R2 U2 R", // OLL 21
    "R U2 R2 U' R2 U' R' U2 R' F R F'", // OLL 22
  ];

  static const _pllAlgorithms = [
    "R U' R U R U R U' R' U' R2", // Ua Perm
    "R2 U R U R' U' R' U' R' U R'", // Ub Perm
    "M2 U M2 U2 M2 U M2", // H Perm
    "M2 U M U2 M' U M2", // Z Perm
    "x R' U R' D2 R U' R' D2 R2", // Aa Perm
    "x R2 D2 R U R' D2 R U' R", // Ab Perm
    "x' R U' R' D R U R' D' R U R' D R U' R' D'", // E Perm
    "R U R' U' R' F R2 U' R' U' R U R' F'", // T Perm
    "F R U' R' U' R U R' F' R U R' U' R' F R F'", // Y Perm
    "R U R' F' R U R' U' R' F R2 U' R' U'", // Jb Perm
    "L' U' L F L' U' L U L F' L2 U L U", // Ja Perm
    "R U R' U' R' F R2 U' R' U' R U R' F'", // T Perm
    "R1 U1 R' U' R' F R2 U' R' U' R U R' F'", // F (simplified prefix setup)
  ];

  /// F2L standard triggers (empty slots)
  static const _f2lTriggers = [
    "R U R'",
    "R U' R'",
    "R U2 R'",
    "L' U' L",
    "L' U L",
    "L' U2 L",
    "F' U' F",
    "F' U F",
    "F' U2 F",
    "B U B'",
    "B U' B'",
    "B U2 B'",
  ];

  /// Master dispatcher for all supported cubes and exercises
  static String generateScrambleFor(CubeType cubeType, ExerciseType exercise,
      {String? specificAlgorithm}) {
    if (exercise == ExerciseType.randomCube ||
        exercise == ExerciseType.beautifulPatterns ||
        exercise == ExerciseType.mixed) {
      return ScrambleGenerator.generateScramble(cubeType);
    }

    switch (cubeType) {
      case CubeType.twoByTwo:
        return _generate2x2Exercise(exercise,
            specificAlgorithm: specificAlgorithm);
      case CubeType.threeByThree:
        return _generate3x3Exercise(exercise,
            specificAlgorithm: specificAlgorithm);
      case CubeType.fourByFour:
      case CubeType.fiveByFive:
      case CubeType.sixBySix:
      case CubeType.sevenBySeven:
        return _generateNxNExercise(cubeType, exercise,
            specificAlgorithm: specificAlgorithm);
      case CubeType.pyraminx:
        return _generatePyraminxExercise(exercise);
      case CubeType.megaminx:
        return _generateMegaminxExercise(exercise);
    }
  }

  static String _generate2x2Exercise(ExerciseType exercise,
      {String? specificAlgorithm}) {
    switch (exercise) {
      case ExerciseType.cross: // Mapped to "First Face" in UI
        return ScrambleGenerator.generate2x2(
            length: 4); // Quick 4-move scramble to train first face
      case ExerciseType.oll:
      case ExerciseType.pll:
      case ExerciseType.recognition:
        // For 2x2 Last Layer, we can just use 3x3 OLLs that only affect corners, e.g. Sune, Anti-Sune, Pi, H
        final algs = [
          "R U R' U R U2 R'", // Sune
          "R U2 R' U' R U' R'", // Anti-Sune
          "F R U R' U' F'", // Adj swap/OLL
          "R U2 R2 U' R2 U' R2 U2 R", // Pi
          "R U R' U' R' F R F'", // T-OLL
        ];
        final alg = specificAlgorithm ?? algs[_random.nextInt(algs.length)];
        return _simplifyScramble(
            "${_randomAUF()} ${_invertAlg(alg)} ${_randomAUF()}");
      case ExerciseType.lookahead:
        return ScrambleGenerator.generate2x2();
      default:
        return ScrambleGenerator.generate2x2();
    }
  }

  static String _generate3x3Exercise(ExerciseType exercise,
      {String? specificAlgorithm}) {
    switch (exercise) {
      case ExerciseType.cross:
        return generateCrossScramble3x3();
      case ExerciseType.f2l:
        return generateF2LScramble3x3();
      case ExerciseType.oll:
        return generateOLLScramble3x3(specificAlgorithm: specificAlgorithm);
      case ExerciseType.pll:
        return generatePLLScramble3x3(specificAlgorithm: specificAlgorithm);
      case ExerciseType.recognition:
        return generateRecognitionScramble3x3();
      case ExerciseType.lookahead:
        return generateLookaheadScramble3x3();
      default:
        return ScrambleGenerator.generate3x3();
    }
  }

  static String _generateNxNExercise(CubeType type, ExerciseType exercise,
      {String? specificAlgorithm}) {
    // For big cubes, F2L, OLL, PLL are essentially 3x3 stage training.
    // We can generate 3x3 scrambles so the user can practice 3x3 stage on a big cube hardware.
    switch (exercise) {
      case ExerciseType.cross:
        return ScrambleGenerator.generateScramble(
            type); // Full scramble to train centers/edges/cross
      case ExerciseType.f2l:
        return generateF2LScramble3x3();
      case ExerciseType.oll:
        return generateOLLScramble3x3(specificAlgorithm: specificAlgorithm);
      case ExerciseType.pll:
        return generatePLLScramble3x3(specificAlgorithm: specificAlgorithm);
      case ExerciseType.recognition:
        return generateRecognitionScramble3x3();
      case ExerciseType.lookahead:
        return generateLookaheadScramble3x3();
      default:
        return ScrambleGenerator.generateScramble(type);
    }
  }

  static String _generatePyraminxExercise(ExerciseType exercise) {
    switch (exercise) {
      case ExerciseType.cross: // Mapped to "V-Shape"
        return ScrambleGenerator.generatePyraminx(
            length: 5); // Short scramble for V-Shape
      case ExerciseType.oll: // Not applicable, fallback to short
      case ExerciseType.pll: // Last Layer (L4E)
        final algs = [
          "L R' L' R", // Sledgehammer
          "R' L R L'", // Hedgeslammer
          "R U R' U R U R'", // Sune
          "R U' R' U' R U' R'", // Anti-sune
        ];
        final alg = algs[_random.nextInt(algs.length)];
        final tips = ['u', 'l', 'r', 'b']
            .where((_) => _random.nextBool() && _random.nextBool())
            .toList();
        return _simplifyScramble("${_invertAlg(alg)} ${tips.join(' ')}");
      case ExerciseType.recognition:
      case ExerciseType.lookahead:
        return ScrambleGenerator.generatePyraminx();
      default:
        return ScrambleGenerator.generatePyraminx();
    }
  }

  static String _generateMegaminxExercise(ExerciseType exercise) {
    switch (exercise) {
      case ExerciseType.cross: // Star
        // Scramble only U and surrounding faces
        return ScrambleGenerator.generatePyraminx(length: 15)
            .replaceAll('L', 'F')
            .replaceAll('R',
                'BR'); // Pseudo scramble, better to just return full short scramble
      case ExerciseType.f2l: // F2L/S2L
      case ExerciseType.oll: // Last Layer OLL
      case ExerciseType.pll: // Last Layer PLL
      case ExerciseType.recognition:
      case ExerciseType.lookahead:
      default:
        return ScrambleGenerator.generateMegaminx();
    }
  }

  /// Generates a Cross scramble (ensures cross is not already solved).
  static String generateCrossScramble3x3({int length = 20}) {
    for (int i = 0; i < 100; i++) {
      final scramble = ScrambleGenerator.generate3x3(length: length);
      final state = CubeState();
      state.applyScramble(scramble);
      if (!state.isCrossSolved()) return scramble;
    }
    return ScrambleGenerator.generate3x3(length: length);
  }

  /// Generates an F2L scramble (Cross is solved, F2L pairs are mixed).
  static String generateF2LScramble3x3() {
    // We achieve this by applying random F2L triggers and U layer turns to an already solved cube.
    // We do this enough times to scramble the F2L slots but keep the cross intact.
    // Finally we simplify the sequence.
    List<String> scrambleMoves = [];

    for (int i = 0; i < 8; i++) {
      // 8 random insertions
      scrambleMoves.add(_randomAUF());
      scrambleMoves.add(_f2lTriggers[_random.nextInt(_f2lTriggers.length)]);
    }
    scrambleMoves.add(_randomAUF()); // Final AUF

    return _simplifyScramble(scrambleMoves.join(" "));
  }

  /// Generates a scramble that results in an OLL case (Cross + F2L solved).
  static String generateOLLScramble3x3({String? specificAlgorithm}) {
    final alg = specificAlgorithm ??
        _ollAlgorithms[_random.nextInt(_ollAlgorithms.length)];
    final setupAlg = _invertAlg(alg);
    final aufPre = _randomAUF();
    final aufPost = _randomAUF();

    final fullRawSequence = "$aufPre $setupAlg $aufPost";
    return _simplifyScramble(fullRawSequence);
  }

  /// Generates a scramble that results in a PLL case (Cross + F2L + OLL solved).
  static String generatePLLScramble3x3({String? specificAlgorithm}) {
    final alg = specificAlgorithm ??
        _pllAlgorithms[_random.nextInt(_pllAlgorithms.length)];
    final setupAlg = _invertAlg(alg);
    final aufPre = _randomAUF();
    final aufPost = _randomAUF();

    final fullRawSequence = "$aufPre $setupAlg $aufPost";
    return _simplifyScramble(fullRawSequence);
  }

  static String _randomAUF() {
    final moves = ["", "U", "U'", "U2"];
    return moves[_random.nextInt(moves.length)];
  }

  static String _invertAlg(String alg) {
    final moves = alg.trim().split(RegExp(r'\s+'));
    final reversed = moves.reversed
        .map((m) {
          if (m.isEmpty) return "";
          if (m.endsWith("'")) return m.replaceAll("'", "");
          if (m.endsWith("2")) return m;
          return "$m'";
        })
        .where((m) => m.isNotEmpty)
        .toList();
    return reversed.join(" ");
  }

  /// Simplifies adjacent moves on the same face (e.g. U U' -> "", R R -> R2).
  static String _simplifyScramble(String rawScramble) {
    final moves =
        rawScramble.split(RegExp(r'\s+')).where((m) => m.isNotEmpty).toList();
    bool changed = true;

    while (changed) {
      changed = false;
      for (int i = 0; i < moves.length - 1; i++) {
        String m1 = moves[i];
        String m2 = moves[i + 1];

        if (m1.isEmpty || m2.isEmpty) continue;

        // Same face?
        if (m1[0] == m2[0]) {
          // Both affect the same face, we can combine them.
          int turns1 = _getTurns(m1);
          int turns2 = _getTurns(m2);
          int totalTurns = (turns1 + turns2) % 4;

          moves.removeAt(i + 1); // remove m2

          if (totalTurns == 0) {
            moves.removeAt(i); // remove m1 as well, they cancel out
          } else {
            moves[i] = _makeMove(m1[0], totalTurns);
          }

          changed = true;
          break; // restart the loop with new list state
        }
      }
    }
    return moves.join(" ");
  }

  static int _getTurns(String move) {
    if (move.endsWith("2")) return 2;
    if (move.endsWith("'")) return 3; // Equivalent to -1 turn modulo 4
    return 1;
  }

  static String _makeMove(String face, int turns) {
    if (turns == 1) return face;
    if (turns == 2) return "${face}2";
    if (turns == 3) return "$face'";
    return "";
  }

  /// Recognition drills: subset of cases.
  static String generateRecognitionScramble3x3() {
    if (_random.nextBool()) {
      return generateOLLScramble3x3();
    } else {
      return generatePLLScramble3x3();
    }
  }

  static String generateLookaheadScramble3x3({int length = 25}) {
    return ScrambleGenerator.generate3x3(length: length); // standard scramble
  }
}
