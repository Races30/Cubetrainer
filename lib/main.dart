import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'models/coach_message.dart';
import 'models/exercise_type.dart';
import 'models/leaderboard_entry.dart';
import 'models/oll_pll_solve.dart';
import 'models/scramble_history_item.dart';
import 'models/session_goal.dart';
import 'models/solve.dart';
import 'models/training_session.dart';
import 'models/training_solve.dart';
import 'screens/home_nav.dart';
import 'utils/ios_platform_helper.dart';

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

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1E293B),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

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

class _IosBouncingScrollBehavior extends MaterialScrollBehavior {
  const _IosBouncingScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class CubeTrainerApp extends StatefulWidget {
  const CubeTrainerApp({super.key});

  @override
  State<CubeTrainerApp> createState() => _CubeTrainerAppState();
}

class _CubeTrainerAppState extends State<CubeTrainerApp> {
  EdgeInsets _platformSafeInsets = EdgeInsets.zero;

  @override
  void initState() {
    super.initState();
    _platformSafeInsets = IosPlatformHelper.getSafeAreaInsets();
    IosPlatformHelper.listenToSafeAreaChanges(() {
      if (!mounted) return;
      final updated = IosPlatformHelper.getSafeAreaInsets();
      if (updated != _platformSafeInsets) {
        setState(() {
          _platformSafeInsets = updated;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final updated = IosPlatformHelper.getSafeAreaInsets();
      if (updated != _platformSafeInsets) {
        setState(() {
          _platformSafeInsets = updated;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CubeTrainer',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const _IosBouncingScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        platform: TargetPlatform.iOS,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF0EA5E9), // Sky Blue accent
          surface: const Color(0xFF0F172A), // Deep Navy background
          primary: const Color(0xFF38BDF8),
          secondary: const Color(0xFF818CF8),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          },
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFF1E293B),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF1E293B),
          surfaceTintColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF1E293B),
          surfaceTintColor: Colors.transparent,
          height: 64,
          indicatorColor: const Color(0xFF38BDF8).withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        final webInsets = _platformSafeInsets == EdgeInsets.zero
            ? IosPlatformHelper.getSafeAreaInsets()
            : _platformSafeInsets;

        final effectivePadding = EdgeInsets.only(
          top: math.max(mq.padding.top, webInsets.top),
          bottom: math.max(mq.padding.bottom, webInsets.bottom),
          left: math.max(mq.padding.left, webInsets.left),
          right: math.max(mq.padding.right, webInsets.right),
        );
        final effectiveViewPadding = EdgeInsets.only(
          top: math.max(mq.viewPadding.top, webInsets.top),
          bottom: math.max(mq.viewPadding.bottom, webInsets.bottom),
          left: math.max(mq.viewPadding.left, webInsets.left),
          right: math.max(mq.viewPadding.right, webInsets.right),
        );

        return MediaQuery(
          data: mq.copyWith(
            padding: effectivePadding,
            viewPadding: effectiveViewPadding,
            textScaler: mq.textScaler.clamp(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.15,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HomeNav(),
    );
  }
}
