import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveSession extends Notifier<String> {
  @override
  String build() {
    // Default to 'main' session on startup
    return 'main';
  }

  void setSession(String sessionId) {
    state = sessionId;
  }
}

final activeSessionProvider = NotifierProvider<ActiveSession, String>(() {
  return ActiveSession();
});
