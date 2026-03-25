import 'package:flutter/material.dart';
import 'package:ayos_game/models/level_config.dart';

import 'package:ayos_game/game/game.dart';
import 'package:ayos_game/game/game_view.dart';
import 'package:ayos_game/game/game_flow_controller.dart';

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
  late GameFlowController flow;

  @override
  void initState() {
    super.initState();

    gameController = GameController();
    countdownController = CountdownController();
    timerController = GameTimerController();
    hintController = HintController();
    animations = GameAnimations();

    flow = GameFlowController(
      game: gameController,
      countdown: countdownController,
      timer: timerController,
      hint: hintController,
      animations: animations,
      config: widget.config,
    );

    flow.onWin = () {
      GameDialogs.showWin(context, () {
        GameNavigation.goHome(context);
      });
    };

    flow.onLose = () {
      GameDialogs.showLose(
        context,
        gameController.correctOrder,
        () => GameNavigation.goHome(context),
        flow.restart,
      );
    };

    flow.init(this);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        GameDialogs.showExit( context, () => GameNavigation.goToLevel(context),
        );
      },

      child: AnimatedBuilder(
        animation: Listenable.merge([
          gameController,
          timerController,
          countdownController,
          hintController,
        ]),
      
        builder: (_, _) {
          return GameView(
            config: widget.config,
            game: gameController,
            timer: timerController,
            countdown: countdownController,
            hint: hintController,
            animations: animations,
            onExit: () => GameDialogs.showExit(
              context,
              () => GameNavigation.goToLevel(context),
            ),

            onGuess:flow.handleGuess,
          );
        },
      )
    );
  }

  @override
  void dispose() {
    flow.dispose();
    super.dispose();
  }

}