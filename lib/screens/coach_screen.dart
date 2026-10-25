import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/solve.dart';
import '../models/coach_message.dart';
import '../services/solve_repository.dart';
import '../services/statistics_repository.dart';
import '../services/deepseek_service.dart';
import '../services/coach_repository.dart';

class CoachScreen extends ConsumerStatefulWidget {
  const CoachScreen({super.key});

  @override
  ConsumerState<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends ConsumerState<CoachScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final String message = _messageController.text.trim();
    if (message.isEmpty) return;

    final coachRepo = ref.read(coachRepositoryProvider);

    setState(() => _isLoading = true);
    _messageController.clear();

    // Add user message to persistent storage
    await coachRepo.addMessage(CoachMessage(
      role: 'user',
      content: message,
      date: DateTime.now(),
    ));

    try {
      final solveRepo = ref.read(solveRepositoryProvider);
      final statsRepo = ref.read(statisticsRepositoryProvider());
      final deepSeekService = ref.read(deepSeekServiceProvider);

      final List<Solve> solves = solveRepo.getSolves();
      final stats = {
        'totalSolves': solves.length,
        'averageTime': statsRepo.calculateMean() ?? 0.0,
        'bestTime': statsRepo.calculateBestTime() ?? 0.0,
        'ao5': statsRepo.calculateAverageOfN(5) ?? 0.0,
        'ao12': statsRepo.calculateAverageOfN(12) ?? 0.0,
      };

      final result = await deepSeekService.getCoachResponse(message, stats);

      // Save AI response
      await coachRepo.addMessage(CoachMessage(
        role: 'system',
        content: result,
        date: DateTime.now(),
      ));
    } catch (e) {
      await coachRepo.addMessage(CoachMessage(
        role: 'system',
        content: 'Errore: ${e.toString()}',
        date: DateTime.now(),
      ));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messages = ref.watch(coachMessagesProvider);

    // Initial greeting if empty
    if (messages.isEmpty && !_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(coachRepositoryProvider).addMessage(CoachMessage(
              role: 'system',
              content:
                  'Ciao! Sono il tuo AI Coach. Chiedimi pure consigli per migliorare!',
              date: DateTime.now(),
            ));
      });
    }

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg.role == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser
                          ? theme.colorScheme.primary
                          : theme.cardTheme.color,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isUser ? 20 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 20),
                      ),
                    ),
                    child: Text(
                      msg.content,
                      style: TextStyle(
                        color: isUser ? Colors.black87 : Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildInputArea(theme),
        ],
      ),
    );
  }

  Widget _buildInputArea(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Chiedi al coach...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _isLoading
              ? const SizedBox(
                  width: 48,
                  height: 48,
                  child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2)))
              : FloatingActionButton.small(
                  onPressed: _sendMessage,
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  heroTag: 'coach_send_fab',
                  child: const Icon(Icons.send_rounded, size: 18),
                ),
        ],
      ),
    );
  }
}
