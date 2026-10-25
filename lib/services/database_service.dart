import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/solve.dart';

class DatabaseService {
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (!_isInitialized) {
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);
      Hive.registerAdapter(SolveAdapter());
      await Hive.openBox<Solve>('solves');
      _isInitialized = true;
    }
  }
}
