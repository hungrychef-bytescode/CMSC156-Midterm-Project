
import 'package:flutter/material.dart';

import 'package:ayos_game/widgets/pill_button.dart';
import 'package:ayos_game/widgets/game_dialog.dart';
import 'package:ayos_game/models/game_item.dart';

class GameDialogs {

  static void showWin(BuildContext context, VoidCallback onExit) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameDialog(
        title: "You guessed all items correctly!",
        actions: [
          PillBtn(label: "Back to Menu", onTap: onExit),
        ],
      ),
    );
  }

  static void showLose(
    BuildContext context,
    List<GameItem> correctOrder,
    VoidCallback onHome,
    VoidCallback onRetry,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameDialog(
        title: "Time's Up!",
        subtitle: "Better luck next time.",
        correctOrder: correctOrder,
        actions: [
          PillBtn(label: "Back to Menu", onTap: onHome),
          PillBtn(label: "Try Again", onTap: onRetry),
        ],
      ),
    );
  }

  static void showExit(
    BuildContext context,
    VoidCallback onExit,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => GameDialog(
        title: "Are you sure you want to exit the game?",
        subtitle: "Current progress will not be saved",
        actions: [
          PillBtn(
            label: "Continue Playing",
            onTap: () => Navigator.of(ctx).pop(),
          ),
          PillBtn(
            label: "Exit Game",
            onTap: onExit,
          ),
        ],
      ),
    );
  }
}