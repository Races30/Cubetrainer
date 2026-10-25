import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session_goal.dart';
import '../services/goal_repository.dart';

class GoalSetupSheet extends ConsumerStatefulWidget {
  final String sessionId;

  const GoalSetupSheet({super.key, required this.sessionId});

  @override
  ConsumerState<GoalSetupSheet> createState() => _GoalSetupSheetState();
}

class _GoalSetupSheetState extends ConsumerState<GoalSetupSheet> {
  GoalType _selectedType = GoalType.ao5;
  final TextEditingController _valueController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _saveGoal() {
    final text = _valueController.text.trim();
    if (text.isEmpty) return;

    final value = double.tryParse(text.replaceAll(',', '.'));
    if (value == null || value <= 0) return;

    ref.read(sessionGoalProvider.notifier).setGoal(
          _selectedType,
          value,
          widget.sessionId,
        );

    Navigator.of(context).pop();
  }

  String _getPlaceholder() {
    switch (_selectedType) {
      case GoalType.ao5:
      case GoalType.ao12:
      case GoalType.bestTime:
        return 'Tempo (es. 15.5)';
      case GoalType.solveCount:
        return 'Numero di Soluzioni (es. 50)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Imposta Obiettivo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<GoalType>(
            decoration: const InputDecoration(
              labelText: 'Tipo di Obiettivo',
              border: OutlineInputBorder(),
            ),
            value: _selectedType,
            items: const [
              DropdownMenuItem(
                value: GoalType.ao5,
                child: Text('Target Ao5'),
              ),
              DropdownMenuItem(
                value: GoalType.ao12,
                child: Text('Target Ao12'),
              ),
              DropdownMenuItem(
                value: GoalType.bestTime,
                child: Text('Miglior Tempo Reale'),
              ),
              DropdownMenuItem(
                value: GoalType.solveCount,
                child: Text('Numero di Solve Totali'),
              ),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedType = val;
                  _valueController.clear();
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _valueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Valore',
              hintText: _getPlaceholder(),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _valueController.clear,
              ),
            ),
            onSubmitted: (_) => _saveGoal(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: _saveGoal,
            child: const Text('Inizia Sfida', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
