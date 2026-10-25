import 'package:cubetrainer/models/solve.dart';
import 'package:cubetrainer/services/qr_migration_service.dart';

void main() {
  try {
    final originalSolves = [
      Solve(id: '1', scramble: 'R U R\'', timeMs: 1200, date: DateTime(2023, 1, 1), cube: '3x3'),
      Solve(id: '2', scramble: 'U D L R', timeMs: 1540, penalty: '+2', date: DateTime(2023, 1, 2), cubeType: CubeType.twoByTwo),
      Solve(id: '3', scramble: 'F B', timeMs: 18000, penalty: 'DNF', date: DateTime(2023, 1, 3), cubeType: CubeType.fourByFour),
    ];

    print('Encoding...');
    final chunks = QrMigrationService.encodeSolvesToQrChunks(originalSolves);
    print('Chunks generated: \${chunks.length}');
    for (int i=0; i<chunks.length; i++) {
      print('Chunk \$i: \${chunks[i].substring(0, 30)}...');
    }

    print('\nDecoding...');
    final buffer = <int, String>{};
    QrDecodeResult? finalResult;

    for (var chunk in chunks.reversed) {
      finalResult = QrMigrationService.decodeQrChunk(chunk, buffer);
      if (finalResult.errorMessage != null) {
        print('Error: \${finalResult.errorMessage}');
        return;
      }
    }

    if (finalResult != null && finalResult.isComplete) {
      print('Decode SUCCESS! Recovered \${finalResult.solves!.length} solves.');
      print('Solve 1 ID: \${finalResult.solves![0].id}');
      print('Solve 2 Penalty: \${finalResult.solves![1].penalty}');
      print('Solve 3 CubeType: \${finalResult.solves![2].cubeType}');
    } else {
      print('Decode FAILED or INCOMPLETE.');
    }
  } catch (e, stack) {
    print('Exception: \$e');
    print(stack);
  }
}
