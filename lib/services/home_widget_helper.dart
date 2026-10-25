import 'package:home_widget/home_widget.dart';
import '../models/solve.dart';
import 'sparkline_generator.dart';
import 'dart:math';

class HomeWidgetHelper {
  static const String androidWidgetName = 'StatsWidgetProvider';
  static const String iosWidgetName = 'StatsWidget'; // App group needed for iOS

  static Future<void> updateWidgetInfo(
      List<Solve> solves, CubeType? activeCube) async {
    try {
      if (solves.isEmpty) {
        await HomeWidget.saveWidgetData<String>('best_time', '--');
        await HomeWidget.saveWidgetData<String>('ao5', '--');
        await HomeWidget.saveWidgetData<String>('ao12', '--');
        await HomeWidget.saveWidgetData<int>('solve_count', 0);
        await HomeWidget.saveWidgetData<String>(
            'cube_type', activeCube?.label ?? '3x3');
        await HomeWidget.saveWidgetData<String>('sparkline_path', '');
      } else {
        final times = solves
            .where((s) => s.penalty != 'DNF')
            .map((s) => s.effectiveTimeMs())
            .toList();
        final bestStr = times.isEmpty ? '--' : _formatMs(times.reduce(min));
        final ao5Str = _calculateAoN(solves, 5);
        final ao12Str = _calculateAoN(solves, 12);

        await HomeWidget.saveWidgetData<String>('best_time', bestStr);
        await HomeWidget.saveWidgetData<String>('ao5', ao5Str);
        await HomeWidget.saveWidgetData<String>('ao12', ao12Str);
        await HomeWidget.saveWidgetData<int>('solve_count', solves.length);
        await HomeWidget.saveWidgetData<String>(
            'cube_type', activeCube?.label ?? '3x3');

        // Sparkline
        final recent10 = solves.reversed.take(10).toList().reversed.toList();
        final recent10Times = recent10.map((s) => s.effectiveTimeMs()).toList();
        final path =
            await SparklineGenerator.generateSparklinePng(recent10Times);
        if (path != null) {
          await HomeWidget.saveWidgetData<String>('sparkline_path', path);
        }
      }

      await HomeWidget.updateWidget(
        androidName: androidWidgetName,
        iOSName: iosWidgetName,
      );
    } catch (e) {
      // Ignore errors if widget is not configured natively yet
    }
  }

  static String _calculateAoN(List<Solve> solves, int n) {
    if (solves.length < n) return '--';
    final recentN = solves.sublist(max(0, solves.length - n));
    final dnfCount = recentN.where((s) => s.penalty == 'DNF').length;
    if (dnfCount > 1) return 'DNF';

    final times = recentN.map((s) => s.effectiveTimeMs().toDouble()).toList();
    times.sort();
    final trimmed = times.sublist(1, times.length - 1);
    if (trimmed.isEmpty) return '--';

    final avg = trimmed.reduce((a, b) => a + b) / trimmed.length;
    return _formatMs(avg.round());
  }

  static String _formatMs(int ms) {
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
    final hundredths = ((ms % 1000) ~/ 10).toString().padLeft(2, '0');
    if (minutes == '00') {
      return '$seconds.$hundredths';
    }
    return '$minutes:$seconds.$hundredths';
  }
}
