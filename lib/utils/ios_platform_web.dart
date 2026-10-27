import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/widgets.dart';

@JS('window')
external JSObject get _window;

double _readNum(JSObject obj, String key) {
  final val = obj.getProperty(key.toJS);
  if (val.isUndefinedOrNull) return 0.0;
  if (val.typeofEquals('number')) {
    return (val as JSNumber).toDartDouble;
  }
  return 0.0;
}

EdgeInsets getPlatformSafeAreaInsets() {
  try {
    if (_window.has('getCubeTrainerSafeAreaInsets')) {
      final res = _window.callMethod('getCubeTrainerSafeAreaInsets'.toJS);
      if (res != null && !res.isUndefinedOrNull && res.typeofEquals('object')) {
        final obj = res as JSObject;
        final top = _readNum(obj, 'top');
        final bottom = _readNum(obj, 'bottom');
        final left = _readNum(obj, 'left');
        final right = _readNum(obj, 'right');
        return EdgeInsets.fromLTRB(left, top, right, bottom);
      }
    }
  } catch (_) {}
  return EdgeInsets.zero;
}

void registerSafeAreaListener(VoidCallback onChanged) {
  try {
    final callback = (() {
      onChanged();
    }).toJS;
    _window.callMethod(
      'addEventListener'.toJS,
      'ios-safe-area-change'.toJS,
      callback,
    );
    _window.callMethod(
      'addEventListener'.toJS,
      'resize'.toJS,
      callback,
    );
    _window.callMethod(
      'addEventListener'.toJS,
      'orientationchange'.toJS,
      callback,
    );
  } catch (_) {}
}

void triggerPlatformHaptic(String style) {
  try {
    if (_window.has('triggerIosHaptic')) {
      _window.callMethod('triggerIosHaptic'.toJS, style.toJS);
    }
  } catch (_) {}
}
