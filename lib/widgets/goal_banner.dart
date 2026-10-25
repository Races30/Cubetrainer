import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session_goal.dart';
import '../services/goal_repository.dart';

class GoalBanner extends ConsumerWidget {
  final double currentAo5;
  final double currentAo12;
  final double currentBest;
  final int currentSolveCount;

  const GoalBanner({
    super.key,
    required this.currentAo5,
    required this.currentAo12,
    required this.currentBest,
    required this.currentSolveCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(sessionGoalProvider);
    if (goal == null) return const SizedBox.shrink();

    double progress = 0.0;
    String label = '';
    String currentValueStr = '';

    // Evaluate progress based on goal type.
    // For times, lower is better. We map progress such that reaching or beating target is 1.0.
    // We need a baseline to calculate progress visually.
    switch (goal.type) {
      case GoalType.ao5:
        label = 'Target Ao5: ${goal.targetValue.toStringAsFixed(2)}s';
        currentValueStr =
            currentAo5 > 0 ? '${currentAo5.toStringAsFixed(2)}s' : '--';
        if (currentAo5 > 0) {
          // Basic progress logic: clamp between 0 and 1
          // If we are at 150% of the target time, progress is 0.
          final startP = goal.targetValue * 1.5;
          progress = 1.0 -
              ((currentAo5 - goal.targetValue) / (startP - goal.targetValue))
                  .clamp(0.0, 1.0);
        }
        break;
      case GoalType.ao12:
        label = 'Target Ao12: ${goal.targetValue.toStringAsFixed(2)}s';
        currentValueStr =
            currentAo12 > 0 ? '${currentAo12.toStringAsFixed(2)}s' : '--';
        if (currentAo12 > 0) {
          final startP = goal.targetValue * 1.5;
          progress = 1.0 -
              ((currentAo12 - goal.targetValue) / (startP - goal.targetValue))
                  .clamp(0.0, 1.0);
        }
        break;
      case GoalType.bestTime:
        label = 'Target Best: ${goal.targetValue.toStringAsFixed(2)}s';
        currentValueStr =
            currentBest > 0 ? '${currentBest.toStringAsFixed(2)}s' : '--';
        if (currentBest > 0) {
          final startP = goal.targetValue * 1.5;
          progress = 1.0 -
              ((currentBest - goal.targetValue) / (startP - goal.targetValue))
                  .clamp(0.0, 1.0);
        }
        break;
      case GoalType.solveCount:
        label = 'Target Solves: ${goal.targetValue.toInt()}';
        currentValueStr = currentSolveCount.toString();
        progress = (currentSolveCount / goal.targetValue).clamp(0.0, 1.0);
        break;
    }

    // Color gradient based on progress
    Color progressColor;
    if (progress < 0.4)
      progressColor = Colors.redAccent;
    else if (progress < 0.8)
      progressColor = Colors.orangeAccent;
    else if (progress < 1.0)
      progressColor = Colors.yellowAccent;
    else
      progressColor = Colors.greenAccent;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: progressColor.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: progressColor.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attuale: $currentValueStr',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  if (progress >= 1.0)
                    const Text('🎯', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: progressColor.withOpacity(0.1),
            color: progressColor,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }
}
