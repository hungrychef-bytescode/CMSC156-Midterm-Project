import 'package:flutter/material.dart';
import 'package:ayos_game/models/level_config.dart';

import 'package:ayos_game/game/game.dart';
import 'package:ayos_game/game/game_view.dart';

import 'package:ayos_game/widgets/pill_button.dart';
import 'package:ayos_game/widgets/game_dialog.dart';


class GameScreen extends StatefulWidget {
  final LevelConfig config;

  const GameScreen({super.key, required this.config});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {

  late GameController gameController;
  late CountdownController countdownController;
  late GameTimerController timerController;
  late HintController hintController;
  late GameAnimations animations;

  @override
  void initState() {
    super.initState();

    gameController = GameController();
    countdownController = CountdownController();
    timerController = GameTimerController();
    hintController = HintController();
    animations = GameAnimations()..init(this);

    timerController.timeLeft = widget.config.totalTime;

    gameController.setup(widget.config.allItems, widget.config.itemCount);

    countdownController.start(() {
      gameController.startGame();

      timerController.start(
        totalTime: widget.config.totalTime,
        onTickUrgent: () => animations.timerShake.forward(from: 0),
        onTimeUp: () {
          gameController.endGame();
          _showLoseDialog();
        }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        gameController,
        timerController,
        countdownController,
        hintController,
      ]),
      
      builder: (_, __) {
        return GameView(
          config: widget.config,
          game: gameController,
          timer: timerController,
          countdown: countdownController,
          hint: hintController,
          animations: animations,

          onGuess: () {
            
            if (hintController.hasGuessed) {
              hintController.reset();
              gameController.hasGuessed = false;
              return;
            }

            final win = gameController.guess();

            if (win) {
              _showWinDialog();
            } else {
              hintController.showHint(
              gameController.countCorrectPositions(),
              );
            }

            animations.hintSlide.forward(from: 0);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    animations.dispose();
    timerController.dispose();
    countdownController.dispose();
    super.dispose();
  }

  void _showWinDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => GameDialog(
      title: "You guessed all items correctly!",
      actions: [
        PillBtn(label: "Back to Menu", onTap: _goHome),
      ],
    ),
  );
}

void _goHome() {
  Navigator.of(context).popUntil((route) => route.isFirst);
}

void _restart() {
  Navigator.of(context).pop();

  gameController.reset(
    widget.config.allItems,
    widget.config.itemCount,
  );

  hintController.reset();

  countdownController.start(() {
    gameController.startGame();

    timerController.start(
      totalTime: widget.config.totalTime,
      onTickUrgent: () => animations.timerShake.forward(from: 0),
      onTimeUp: () {
        gameController.endGame();
        _showLoseDialog();
      },
    );
  });
}

void _showLoseDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => GameDialog(
      title: "Time's Up!",
      subtitle: "Better luck next time.",
      correctOrder: gameController.correctOrder,
      actions: [
        PillBtn(label: "Back to Menu", onTap: _goHome),
        PillBtn(label: "Try Again", onTap: _restart),
      ],
    ),
  );
}
}