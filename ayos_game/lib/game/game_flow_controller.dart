import 'package:flutter/material.dart';
import 'package:ayos_game/models/level_config.dart';

import 'package:ayos_game/game/game.dart';

class GameFlowController {
  final GameController game;
  final CountdownController countdown;
  final GameTimerController timer;
  final HintController hint;
  final GameAnimations animations;

  final LevelConfig config;

  VoidCallback? onWin;
  VoidCallback? onLose;

  GameFlowController({
    required this.game,
    required this.countdown,
    required this.timer,
    required this.hint,
    required this.animations,
    required this.config,
  });

  void init(TickerProvider vsync) {
    animations.init(vsync);

    timer.timeLeft = config.totalTime;

    game.setup(config.allItems, config.itemCount);

    countdown.start(() {
      game.startGame();

      timer.start(
        totalTime: config.totalTime,
        onTickUrgent: () => animations.timerShake.forward(from: 0),
        onTimeUp: () {
          game.endGame();
          onLose?.call();
        },
      );
    });
  }

  void handleGuess() {
    if (hint.hasGuessed) {
      hint.reset();
      game.hasGuessed = false;
      animations.hintSlide.reverse();
      return;
    }

    final win = game.guess();

    if (win) {
      onWin?.call();
    } else {
      hint.showHint(game.countCorrectPositions());
    }

    animations.hintSlide.forward(from: 0);
  }

  void restart() {
    game.reset(config.allItems, config.itemCount);
    hint.reset();

    countdown.start(() {
      game.startGame();

      timer.start(
        totalTime: config.totalTime,
        onTickUrgent: () => animations.timerShake.forward(from: 0),
        onTimeUp: () {
          game.endGame();
          onLose?.call();
        },
      );
    });
  }

  void dispose() {
    animations.dispose();
    timer.dispose();
    countdown.dispose();
  }
}