
// PRE-GAME 5-SECOND COUNTDOWN ________________________________

import 'package:flutter/material.dart';
import 'dart:async';

// class CountdownController:
// for the 5 seconds countdown timer before a game begins

class CountdownController extends ChangeNotifier {
  int countdown = 5;
  bool isRunning = false;

  Timer? _timer;

  void start(VoidCallback onFinish) {
    countdown = 5;
    isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      countdown--;
      notifyListeners();

      if (countdown <= 0) {
        t.cancel();
        isRunning = false;
        notifyListeners();
        onFinish();
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}