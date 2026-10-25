import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Required for Ref
import '../models/solve.dart';
import 'package:cubetrainer/services/solve_repository.dart';

part 'statistics_repository.g.dart';

@riverpod
StatisticsRepository statisticsRepository(Ref ref,
    {CubeType? cubeType, String? sessionId}) {
  return StatisticsRepository(ref.watch(solveRepositoryProvider));
}

class StatisticsRepository {
  final SolveRepository _solveRepository;

  StatisticsRepository(this._solveRepository);

  String formatMs(int ms) {
    if (ms < 0) return "--:--.--";
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
    final hundredths = ((ms % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$hundredths';
  }

  double? calculateMean({CubeType? cubeType, String? sessionId}) {
    final solves =
        _solveRepository.getSolves(cubeType: cubeType, sessionId: sessionId);
    final times = solves
        .where((s) => s.penalty != 'DNF')
        .map((s) => s.effectiveTimeMs().toDouble())
        .toList();
    if (times.isEmpty) return null;
    return times.reduce((a, b) => a + b) / times.length;
  }

  double? calculateBestTime({CubeType? cubeType, String? sessionId}) {
    final solves =
        _solveRepository.getSolves(cubeType: cubeType, sessionId: sessionId);
    final times = solves
        .where((s) => s.penalty != 'DNF')
        .map((s) => s.effectiveTimeMs().toDouble())
        .toList();
    if (times.isEmpty) return null;
    return times.reduce((a, b) => a < b ? a : b);
  }

  double? calculateWorstTime({CubeType? cubeType, String? sessionId}) {
    final solves =
        _solveRepository.getSolves(cubeType: cubeType, sessionId: sessionId);
    final times = solves
        .where((s) => s.penalty != 'DNF')
        .map((s) => s.effectiveTimeMs().toDouble())
        .toList();
    if (times.isEmpty) return null;
    return times.reduce((a, b) => a > b ? a : b);
  }

  double? calculateAverageOfN(int n, {CubeType? cubeType, String? sessionId}) {
    final solves =
        _solveRepository.getSolves(cubeType: cubeType, sessionId: sessionId);
    if (solves.length < n) return null;

    final recentN = solves.sublist(max(0, solves.length - n));
    if (recentN.length < n) return null;

    // In an Ao5 or Ao12, a DNF is treated as the worst possible time (infinity).
    // If there is more than 1 DNF in an Ao5 (or appropriately for Ao12), the whole average is DNF.
    // effectiveTimeMs() returns 1<<30 for DNF, which naturally sorts to the worst.
    final times = recentN.map((s) => s.effectiveTimeMs().toDouble()).toList();

    // Count DNFs
    final dnfCount = recentN.where((s) => s.penalty == 'DNF').length;
    final allowedDrops = (n == 5)
        ? 1
        : 1; // WCA allows dropping 1 best and 1 worst for both Ao5 and Ao12

    if (dnfCount > allowedDrops) return -1.0; // -1 represents DNF average

    // Take the last N solves (most recent ones)
    final lastNSolvesList = times.sublist(max(0, times.length - n));
    if (lastNSolvesList.length < n) return null;

    final sortedTimes = List<double>.from(lastNSolvesList)..sort();

    // Remove best and worst
    final trimmedSolves = sortedTimes.sublist(1, sortedTimes.length - 1);
    if (trimmedSolves.isEmpty) return null;

    return trimmedSolves.reduce((a, b) => a + b) / trimmedSolves.length;
  }
}
