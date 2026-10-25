import 'package:flutter_test/flutter_test.dart';
import 'package:cubetrainer/models/solve.dart';
import 'package:cubetrainer/services/qr_migration_service.dart';

void main() {
  test('QR Migration Encoding and Decoding', () {
    final originalSolves = [
      Solve(id: '1', scramble: 'R U R\'', timeMs: 1200, date: DateTime(2023, 1, 1), cube: '3x3'),
      Solve(id: '2', scramble: 'U D L R', timeMs: 1540, penalty: '+2', date: DateTime(2023, 1, 2), cubeType: CubeType.twoByTwo),
      Solve(id: '3', scramble: 'F B', timeMs: 18000, penalty: 'DNF', date: DateTime(2023, 1, 3), cubeType: CubeType.fourByFour),
    ];

    // Encode
    final chunks = QrMigrationService.encodeSolvesToQrChunks(originalSolves);
    expect(chunks.isNotEmpty, true);
    
    // Verify Header
    for (int i=0; i<chunks.length; i++) {
      expect(chunks[i].startsWith('CT_QR:${chunks.length}:$i:'), true);
    }

    // Decode out of order
    final reversedChunks = chunks.reversed.toList();
    final buffer = <int, String>{};
    
    QrDecodeResult? finalResult;

    for (var chunk in reversedChunks) {
      finalResult = QrMigrationService.decodeQrChunk(chunk, buffer);
      if (finalResult.errorMessage != null) {
        fail(finalResult.errorMessage!);
      }
    }

    expect(finalResult, isNotNull);
    expect(finalResult!.isComplete, true);
    expect(finalResult.solves!.length, 3);
    
    // Check data integrity
    expect(finalResult.solves![0].id, originalSolves[0].id);
    expect(finalResult.solves![1].scramble, originalSolves[1].scramble);
    expect(finalResult.solves![2].cubeType, originalSolves[2].cubeType);
  });
}
