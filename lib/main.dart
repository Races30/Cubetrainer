import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'models/solve.dart';
import 'screens/home_nav.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/exercise_type.dart';
import 'models/coach_message.dart';
import 'models/scramble_history_item.dart';
import 'models/training_session.dart';
import 'models/session_goal.dart';
import 'models/training_solve.dart';
import 'models/leaderboard_entry.dart';
import 'models/oll_pll_solve.dart';

Future<Box<T>> _openBoxWithRecovery<T>(String boxName) async {
  try {
    return await Hive.openBox<T>(boxName);
  } catch (e) {
    debugPrint(
        'Errore apertura box $boxName: $e. Tento il ripristino eliminando i dati corrotti...');
    await Hive.deleteBoxFromDisk(boxName);
    return await Hive.openBox<T>(boxName);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    try {
      await dotenv.load(fileName: "assets/.env");
    } catch (_) {
      // .env not found, using fallback
    }

    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);
    }
    Hive.registerAdapter(SolveAdapter());
    Hive.registerAdapter(CubeTypeAdapter());
    Hive.registerAdapter(CoachMessageAdapter());
    Hive.registerAdapter(ScrambleHistoryItemAdapter());
    Hive.registerAdapter(TrainingSessionAdapter());
    Hive.registerAdapter(TrainingSolveAdapter());
    Hive.registerAdapter(LeaderboardEntryAdapter());
    Hive.registerAdapter(OllPllSolveAdapter());
    Hive.registerAdapter(GoalTypeAdapter());
    Hive.registerAdapter(SessionGoalAdapter());
    Hive.registerAdapter(GoalAchievementAdapter());

    // Missing adapters that caused Hive typeId errors
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ExerciseTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(EvaluationModeAdapter());
    }

    await _openBoxWithRecovery<Solve>('solves');
    await _openBoxWithRecovery<CoachMessage>('coach_messages');
    await _openBoxWithRecovery<ScrambleHistoryItem>('scramble_history');
    await _openBoxWithRecovery<TrainingSession>('training_sessions');
    await _openBoxWithRecovery<TrainingSolve>('training_solves');
    await _openBoxWithRecovery<LeaderboardEntry>('leaderboard_box');
    await _openBoxWithRecovery<OllPllSolve>('oll_pll_solves');
    await _openBoxWithRecovery<GoalAchievement>('goal_achievements');

    runApp(const ProviderScope(child: CubeTrainerApp()));
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Errore di inizializzazione: $e')),
      ),
    ));
  }
}

class CubeTrainerApp extends StatelessWidget {
  const CubeTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scramble',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF0EA5E9), // Sky Blue accent
          surface: const Color(0xFF0F172A), // Deep Navy background
          primary: const Color(0xFF38BDF8),
          secondary: const Color(0xFF818CF8),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          elevation: 0,
          centerTitle: true,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF1E293B),
          indicatorColor: const Color(0xFF38BDF8).withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      home: const HomeNav(),
    );
  }
}
