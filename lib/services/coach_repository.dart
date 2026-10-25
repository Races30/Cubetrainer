import 'package:hive/hive.dart';
import '../models/coach_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coach_repository.g.dart';

class CoachRepository {
  final Box<CoachMessage> _box;

  CoachRepository(this._box);

  List<CoachMessage> getMessages() {
    return _box.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> addMessage(CoachMessage msg) async {
    await _box.add(msg);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  Stream<BoxEvent> watchMessages() {
    return _box.watch();
  }
}

@riverpod
CoachRepository coachRepository(CoachRepositoryRef ref) {
  final box = Hive.box<CoachMessage>('coach_messages');
  return CoachRepository(box);
}

@riverpod
List<CoachMessage> coachMessages(CoachMessagesRef ref) {
  final repository = ref.watch(coachRepositoryProvider);
  final subscription = repository.watchMessages().listen((_) {
    ref.invalidateSelf();
  });
  ref.onDispose(subscription.cancel);
  return repository.getMessages();
}
