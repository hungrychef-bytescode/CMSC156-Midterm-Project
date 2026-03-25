import 'dart:async';
import 'package:flutter/material.dart';

class GameTimerController extends ChangeNotifier {
  late int timeLeft;
  bool isRunning = false;

  Timer? _timer;

  void init(int totalTime) {
    timeLeft = totalTime;
  }
  void start({
    required int totalTime,
    required VoidCallback onTickUrgent,
    required VoidCallback onTimeUp,
  }) {
    timeLeft = totalTime;
    isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      timeLeft--;
      notifyListeners();

      if (timeLeft <= 10) {
        onTickUrgent();
      }

      if (timeLeft <= 0) {
        t.cancel();
        isRunning = false;
        notifyListeners();
        onTimeUp();
      }
    });
  }

  void stop() {
    _timer?.cancel();
    isRunning = false;
  }

  String get display {
    final m = (timeLeft ~/ 60).toString().padLeft(2, '0');
    final s = (timeLeft % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  bool get isUrgent => timeLeft <= 10 && isRunning;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}