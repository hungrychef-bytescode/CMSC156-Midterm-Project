
// COUNTDOWN GAME TIMER ________________________________

import 'dart:async';
import 'package:flutter/material.dart';

class GameTimerController extends ChangeNotifier {
  late int timeLeft;
  bool isRunning = false;

  Timer? _timer; // priv bc nothing outside class should touch it directly

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

      if (timeLeft <= 10) { // trigger urgent tick when 10 seconds or less remain
        onTickUrgent();
      }

      if (timeLeft <= 0) { // time's up
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
    final m = (timeLeft ~/ 60).toString().padLeft(2, '0'); // format as MM:SS
    final s = (timeLeft % 60).toString().padLeft(2, '0'); 
    return "$m:$s";
  }

  bool get isUrgent => timeLeft <= 10 && isRunning; 

  @override
  void dispose() { // ensure timer is cancelled when controller is disposed
    _timer?.cancel();
    super.dispose();
  }
}