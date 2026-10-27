import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'ios_platform_stub.dart'
    if (dart.library.js_interop) 'ios_platform_web.dart';

class IosPlatformHelper {
  static EdgeInsets getSafeAreaInsets() => getPlatformSafeAreaInsets();

  static void listenToSafeAreaChanges(VoidCallback onChanged) {
    registerSafeAreaListener(onChanged);
  }

  static void lightImpact() {
    triggerPlatformHaptic('light');
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    triggerPlatformHaptic('medium');
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    triggerPlatformHaptic('heavy');
    HapticFeedback.heavyImpact();
  }

  static void selectionClick() {
    triggerPlatformHaptic('selection');
    HapticFeedback.selectionClick();
  }
}
