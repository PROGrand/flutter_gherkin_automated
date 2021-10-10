import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clock/src/clock.dart';

class _FastClock extends Clock {
  int _now = Clock().now().microsecondsSinceEpoch;

  @override
  DateTime now() {
    return DateTime.fromMicrosecondsSinceEpoch(_now * 2);
  }

  void add(Duration duration) {
    _now += duration.inMicroseconds;
  }
}

class AutomatedBindingNoDelay extends AutomatedTestWidgetsFlutterBinding {
  static bool _initialized = false;

  static void init() {
    if (!_initialized) {
      _initialized = true;
      AutomatedBindingNoDelay();
    }
  }

  static bool get initialized => _initialized;

  AutomatedBindingNoDelay() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    if (binding is LiveTestWidgetsFlutterBinding) {
      debugSemanticsDisableAnimations = true;

      binding.framePolicy =
          LiveTestWidgetsFlutterBindingFramePolicy.benchmarkLive;
    }
  }

  @override
  Clock get clock {
    return _clock;
  }

  _FastClock _clock = _FastClock();

  @override
  void addTime(Duration duration) {
    _clock.add(duration);
  }

  @override
  bool get disableAnimations => true;

  @override
  bool get disableShadows => true;

  @override
  Future<void> delayed(Duration duration) async {
    if (Duration.zero != duration) {
      var microseconds = duration.inMicroseconds ~/ 10.0;

      await super.delayed(Duration(microseconds: microseconds));
    }
  }
}
