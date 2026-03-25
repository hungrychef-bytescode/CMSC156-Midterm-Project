import 'package:flutter/material.dart';
import 'package:ayos_game/widgets/action_button.dart';

class GameFooter extends StatelessWidget {
  final bool hasGuessed;
  final bool enabled;
  final VoidCallback onGuess;

  const GameFooter({
    super.key,
    required this.hasGuessed,
    required this.onGuess,
    required this.enabled
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ActionButton(
          label: hasGuessed ? "Subukan ulit" : "Hulaan na!",
          onTap: onGuess,
          enabled: enabled
        ),
      )
    );
  }
}