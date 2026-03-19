import 'package:flutter/material.dart';
import "start_screen.dart";
import "level_screen.dart";
import "game_screen.dart";
import "game_config.dart";

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/startScreen": (context) => const StartScreen(),
        "/levelScreen": (context) => const LevelScreen(),
        "/game": (context) => GameScreen(
          config: configForLevel(
            ModalRoute.of(context)!.settings.arguments as String? ?? "Easy",
          ),
        ),
      },
      home: const StartScreen(),
      builder: (context, child) {
        return Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 450,
              height: 800,
              child: child!,
            ),
          ),
        );
      },
    );
  }
}