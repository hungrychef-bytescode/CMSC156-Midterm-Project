
// GAME BACKGROUND WIDGET DISPLAY ________________________________

import 'package:flutter/material.dart';
import 'package:ayos_game/assets.dart';
import 'dart:ui';


class GameBackground extends StatelessWidget {
  const GameBackground({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(Assets.gameBG, fit: BoxFit.cover),

        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 2),
          child: Container(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ],
    );
  }
}