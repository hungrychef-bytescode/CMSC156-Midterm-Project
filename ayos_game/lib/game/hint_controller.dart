import 'package:flutter/material.dart';

class HintController extends ChangeNotifier {
  bool hasGuessed = false;
  String? message;

  void showHint(int hits) {
    hasGuessed = true;

    message = switch (hits) {
      0 => "walang tama :(",
      1 => "isa ang tama!",
      2 => "dalawa ang tama!",
      _ => "$hits ang tama!",
    };

    notifyListeners();
  }

  void reset() {
    hasGuessed = false;
    message = null;
    notifyListeners();
  }
}