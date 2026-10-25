import 'package:flutter_test/flutter_test.dart';
import 'package:cubetrainer/services/training_scrambler.dart';
import 'package:cubetrainer/services/cube_state.dart';

void main() {
  group('TrainingScrambler Tests', () {
    test('generateCrossScramble3x3 should not return a solved cross', () {
      for (int i = 0; i < 50; i++) {
        final scramble = TrainingScrambler.generateCrossScramble3x3();
        final state = CubeState();
        state.applyScramble(scramble);
        expect(state.isCrossSolved(), isFalse,
            reason: 'Scramble $scramble resulted in solved cross');
      }
    });

    test('generateOLLScramble3x3 should return non-empty scramble', () {
      final scramble = TrainingScrambler.generateOLLScramble3x3();
      expect(scramble, isNotEmpty);
      expect(scramble.split(' ').length, greaterThan(3));
    });

    test('generatePLLScramble3x3 should return non-empty scramble', () {
      final scramble = TrainingScrambler.generatePLLScramble3x3();
      expect(scramble, isNotEmpty);
      expect(scramble.split(' ').length, greaterThan(3));
    });

    test('CubeState basics', () {
      final state = CubeState();
      expect(state.isCrossSolved(), isTrue); // Initial state is solved

      state.applyMove("R");
      expect(state.isCrossSolved(), isFalse); // R breaks cross

      state.applyMove("R'");
      expect(state.isCrossSolved(), isTrue); // R R' restores it
    });
  });
}
