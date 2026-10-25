import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/session_goal.dart';
import '../models/solve.dart';

class GoalRepository {
  final Box<GoalAchievement> _box =
      Hive.box<GoalAchievement>('goal_achievements');

  List<GoalAchievement> getAllAchievements() {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  void saveAchievement(GoalAchievement achievement) {
    _box.put(achievement.id, achievement);
  }

  void deleteAchievement(String id) {
    _box.delete(id);
  }

  void clearAll() {
    _box.clear();
  }
}

final goalRepositoryProvider = Provider((ref) => GoalRepository());

class SessionGoalNotifier extends StateNotifier<SessionGoal?> {
  SessionGoalNotifier() : super(null);

  void setGoal(GoalType type, double targetValue, String sessionId) {
    state = SessionGoal(
      sessionId: sessionId,
      type: type,
      targetValue: targetValue,
    );
  }

  void clearGoal() {
    state = null;
  }

  /// Called after a solve to check if the current goal is met.
  /// If it is met, it returns a GoalAchievement object and clears the goal.
  GoalAchievement? checkGoalAchievement({
    required double currentAo5,
    required double currentAo12,
    required double currentBest,
    required int currentSolveCount,
    required CubeType cubeType,
  }) {
    final goal = state;
    if (goal == null) return null;

    bool achieved = false;
    double actualValue = 0;

    switch (goal.type) {
      case GoalType.ao5:
        if (currentAo5 > 0 && currentAo5 <= goal.targetValue) {
          achieved = true;
          actualValue = currentAo5;
        }
        break;
      case GoalType.ao12:
        if (currentAo12 > 0 && currentAo12 <= goal.targetValue) {
          achieved = true;
          actualValue = currentAo12;
        }
        break;
      case GoalType.bestTime:
        if (currentBest > 0 && currentBest <= goal.targetValue) {
          achieved = true;
          actualValue = currentBest;
        }
        break;
      case GoalType.solveCount:
        if (currentSolveCount >= goal.targetValue.toInt()) {
          achieved = true;
          actualValue = currentSolveCount.toDouble();
        }
        break;
    }

    if (achieved) {
      final achievement = GoalAchievement(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        type: goal.type,
        targetValue: goal.targetValue,
        actualValue: actualValue,
        sessionId: goal.sessionId,
        cubeType: cubeType,
      );

      clearGoal(); // Auto-reset when achieved
      return achievement;
    }

    return null;
  }
}

final sessionGoalProvider =
    StateNotifierProvider<SessionGoalNotifier, SessionGoal?>((ref) {
  return SessionGoalNotifier();
});
