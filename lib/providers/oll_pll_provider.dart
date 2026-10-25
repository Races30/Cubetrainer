import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/oll_pll_case.dart';
import '../services/oll_pll_data.dart';
import '../services/oll_pll_repository.dart';
import '../providers/selected_cube_type.dart';
import 'dart:math';

// Filter State: what is the user training? 'oll', 'pll', or 'both'
enum OllPllFilter { oll, pll, both }

final ollPllFilterProvider =
    StateProvider<OllPllFilter>((ref) => OllPllFilter.both);

// Provides the filtered list of cases based on selection
final filteredOllPllCasesProvider = Provider<List<OllPllCase>>((ref) {
  final activeCube = ref.watch(selectedCubeTypeProvider);
  final filter = ref.watch(ollPllFilterProvider);

  final puzzleCases = allCasesByPuzzle[activeCube] ?? [];

  if (filter == OllPllFilter.both) return puzzleCases;

  if (filter == OllPllFilter.oll) {
    return puzzleCases
        .where((c) =>
            c.category.toUpperCase().contains('OLL') ||
            c.category.toUpperCase() == 'CLL' ||
            c.category.toUpperCase() == 'L4E')
        .toList();
  } else {
    return puzzleCases
        .where((c) =>
            c.category.toUpperCase().contains('PLL') ||
            c.category.toUpperCase() == 'PBL' ||
            c.category.toUpperCase() == 'L4E')
        .toList();
  }
});

// Provides stats for a specific case
final ollPllStatsProvider =
    Provider.family<Map<String, int?>, String>((ref, caseId) {
  final repo = ref.watch(ollPllRepositoryProvider);
  // Using a stream or watch? Since Hive Box is synchronous but not reactive natively via simple get,
  // we might just need to rely on ref.refresh when a solve is added.
  // We'll create a notifier to trigger UI updates.
  return {
    'count': repo.getSolveCount(caseId),
    'ao5': repo.getAo5(caseId),
    'best': repo.getBestTime(caseId),
  };
});

// A StateNotifier to manage the "current" case being trained
class CurrentOllPllCaseNotifier extends StateNotifier<OllPllCase?> {
  final Ref ref;
  final Random _rnd = Random();
  bool _isLocked = false;
  bool get isLocked => _isLocked;

  CurrentOllPllCaseNotifier(this.ref) : super(null);

  void setCase(OllPllCase newCase, {bool isLocked = true}) {
    state = newCase;
    _isLocked = isLocked;
  }

  void unlock() {
    _isLocked = false;
  }

  void nextRandomCase() {
    if (_isLocked && state != null) {
      // Loop the same case, so do nothing.
      return;
    }

    final availableCases = ref.read(filteredOllPllCasesProvider);
    if (availableCases.isEmpty) return;

    int nextIndex = _rnd.nextInt(availableCases.length);
    if (availableCases.length > 1 && availableCases[nextIndex] == state) {
      nextIndex = (nextIndex + 1) % availableCases.length;
    }

    state = availableCases[nextIndex];
  }
}

final currentOllPllCaseProvider =
    StateNotifierProvider<CurrentOllPllCaseNotifier, OllPllCase?>((ref) {
  return CurrentOllPllCaseNotifier(ref);
});

// We need a way to notify stats listeners when a new solve is saved.
// A simple trigger provider that updates its state to refresh families.
final statsRefreshTriggerProvider = StateProvider<int>((ref) => 0);

final ollPllStatsReactiveProvider =
    Provider.family<Map<String, int?>, String>((ref, caseId) {
  ref.watch(statsRefreshTriggerProvider); // Rebuild when trigger changes
  final repo = ref.watch(ollPllRepositoryProvider);
  return {
    'count': repo.getSolveCount(caseId),
    'ao5': repo.getAo5(caseId),
    'best': repo.getBestTime(caseId),
  };
});
