import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise_type.dart';
import '../models/training_solve.dart';
import '../models/training_session.dart';
import '../models/solve.dart';
import '../services/training_repository.dart';
import '../services/deepseek_service.dart';

class TrainingReportScreen extends ConsumerStatefulWidget {
  final List<TrainingSolve> solves;
  final String sessionId;
  final ExerciseType type;
  final CubeType cubeType;

  const TrainingReportScreen({
    super.key,
    required this.solves,
    required this.sessionId,
    required this.type,
    required this.cubeType,
  });

  @override
  ConsumerState<TrainingReportScreen> createState() =>
      _TrainingReportScreenState();
}

class _TrainingReportScreenState extends ConsumerState<TrainingReportScreen> {
  String? _coachAdvice;
  bool _isLoadingAdvice = false;

  @override
  void initState() {
    super.initState();
    _saveSession();
    _fetchCoachAdvice();
  }

  void _saveSession() {
    final avg = widget.solves.isEmpty
        ? 0.0
        : widget.solves.map((s) => s.totalTimeMs).reduce((a, b) => a + b) /
            widget.solves.length;

    final session = TrainingSession(
      sessionId: widget.sessionId,
      type: widget.type,
      date: DateTime.now(),
      totalSolves: widget.solves.length,
      successPercentage: 100.0, // Simplification
      metadata: {'average': avg.toStringAsFixed(2)},
    );

    ref.read(trainingRepositoryProvider).saveSession(session);
  }

  Future<void> _fetchCoachAdvice() async {
    setState(() => _isLoadingAdvice = true);
    try {
      final summary = _generateSessionSummary();
      final advice = await ref.read(deepSeekServiceProvider).getCoachResponse(
            "Analizza questa sessione di allenamento di tipo ${widget.type.name} (sul puzzle: ${widget.cubeType.label}) e dai consigli pratici.",
            summary,
          );
      setState(() {
        _coachAdvice = advice;
        _isLoadingAdvice = false;
      });
    } catch (e) {
      setState(() {
        _coachAdvice = "Errore nel recupero dei consigli: $e";
        _isLoadingAdvice = false;
      });
    }
  }

  Map<String, dynamic> _generateSessionSummary() {
    if (widget.solves.isEmpty) return {};

    final times = widget.solves.map((s) => s.totalTimeMs).toList();
    final avg = times.reduce((a, b) => a + b) / times.length;
    final best = times.reduce((a, b) => a < b ? a : b);

    // Phase breakdown
    Map<String, double> phaseAvgs = {};
    if (widget.solves.isNotEmpty && widget.solves.first.phaseTimes.isNotEmpty) {
      for (var label in widget.solves.first.phaseTimes.keys) {
        final phaseTimes =
            widget.solves.map((s) => s.phaseTimes[label] ?? 0).toList();
        phaseAvgs[label] =
            phaseTimes.reduce((a, b) => a + b) / phaseTimes.length;
      }
    }

    return {
      'totalSolves': widget.solves.length,
      'averageTime': (avg / 1000).toStringAsFixed(2),
      'bestTime': (best / 1000).toStringAsFixed(2),
      'ao5': times.length >= 5 ? 'Vedi fasi' : 'N/A',
      'ao12': times.length >= 12 ? 'Vedi fasi' : 'N/A',
      'phaseBreakdown': phaseAvgs,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = _generateSessionSummary();

    return Scaffold(
      appBar: AppBar(
        title: const Text('REPORT SESSIONE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatCard(theme, summary),
            const SizedBox(height: 20),
            _buildPhaseChart(
                theme, summary['phaseBreakdown'] as Map<String, double>?),
            const SizedBox(height: 20),
            _buildCoachCard(theme),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, Map<String, dynamic> summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Solves', summary['totalSolves'].toString()),
                _buildStatItem('Media', '${summary['averageTime']}s'),
                _buildStatItem('Best', '${summary['bestTime']}s'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPhaseChart(ThemeData theme, Map<String, double>? phases) {
    if (phases == null || phases.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('MEDIA PER FASE',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.grey)),
        const SizedBox(height: 12),
        ...phases.entries.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text('${(e.value / 1000).toStringAsFixed(2)}s',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: e.value / 30000, // Normalized to 30s
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCoachCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              const Text('CONSIGLIO DEL COACH',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoadingAdvice)
            const Center(child: CircularProgressIndicator())
          else if (_coachAdvice != null)
            Text(
              _coachAdvice!,
              style: const TextStyle(height: 1.5),
            )
          else
            const Text('Nessun consiglio disponibile.'),
        ],
      ),
    );
  }
}
