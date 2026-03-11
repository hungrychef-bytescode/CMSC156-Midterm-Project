import 'package:flutter/material.dart';
import 'dart:async';

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
  void didChangeDependencies(){
    super.didChangeDependencies();

    final level = ModalRoute.of(context)!.settings.arguments as String;

    if (level == "easy"){
      gameTime = 60;
      items = 3;
    } else if (level == "average") {
      gameTime = 45;
      items = 4;
    } else if (level == "difficult") {
      gameTime = 30;
      items = 5;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final level = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text("Level: $level")),
      body: Center(child: Column(children: [Text("")],)));
  }
  
}