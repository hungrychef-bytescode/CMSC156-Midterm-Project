
// MAIN GAME UI LAYOUT ________________________________

import 'package:flutter/material.dart';
import 'package:ayos_game/game/game.dart';
import 'package:ayos_game/widgets/countdown.dart';
import 'package:ayos_game/widgets/hint_bubble.dart';
import 'package:ayos_game/models/level_config.dart';

class GameView extends StatelessWidget {
  final LevelConfig config;
  final GameController game;
  final GameTimerController timer;
  final CountdownController countdown;
  final HintController hint;
  final GameAnimations animations;

  final VoidCallback onGuess;

  const GameView({
    super.key,
    required this.config,
    required this.game,
    required this.timer,
    required this.countdown,
    required this.hint,
    required this.animations,
    required this.onGuess,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GameAppBar(
        level: config.level,
        timer: timer,
        shake: animations.shakeAnim,
      ),
      
      body: Stack(
        children: [
          const GameBackground(),
          
          AnimatedBuilder(
            animation: hint,
            builder: (_, __) {
              if (hint.message == null) return const SizedBox();
              
              return Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: FadeTransition(
                    opacity: animations.hintFade,
                    child: SlideTransition(
                      position: animations.hintSlideAnim,
                      child: HintBubble(message: hint.message!),
                    ),
                  ),
                ),
              );
            },
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: const Offset(0, 150),
              child: Image.asset("assets/images/box.png", width: 450),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: const Offset(0, 25),
              child: Container(
                width: 500,
                height: 100,
                color: const Color(0xFF382507),
              ),
            ),
          ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 265),
            child: GameBoard(
              items: game.playerOrder,
              width: config.itemWidth,
              onSwap: (from, to) {
                game.swap(from, to);
                hint.reset();
              },
            ),
          ),
        ),

        GameFooter(
          hasGuessed: hint.hasGuessed,
          enabled: game.gameStarted && !game.gameOver,
          onGuess: onGuess,
        ),

        CountdownOverlay(
          controller: countdown,
          scaleAnimation: animations.countdownScale,
        ),
      ],
    ),
  );
  }
}