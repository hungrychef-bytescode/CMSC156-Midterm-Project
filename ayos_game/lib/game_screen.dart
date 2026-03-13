import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:ui';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int gameTime = 0;
  int items = 0;

  int countdown = 5;
  bool gameStarted = false;

  Timer? timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final level = ModalRoute.of(context)!.settings.arguments as String;

    if (level == "Easy") {
      gameTime = 60;
      items = 3;
    } else if (level == "Average") {
      gameTime = 45;
      items = 4;
    } else if (level == "Difficult") {
      gameTime = 30;
      items = 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = ModalRoute.of(context)!.settings.arguments as String;
    return Container();
  }
}