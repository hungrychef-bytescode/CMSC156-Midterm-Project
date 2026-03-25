import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayos_game/game/game_timer_controller.dart';

class GameTimerWidget extends StatelessWidget {
  final GameTimerController controller;
  final Animation<Offset> shakeAnimation;

  const GameTimerWidget({
    super.key,
    required this.controller,
    required this.shakeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        return SlideTransition(
          position: shakeAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: controller.isUrgent
                  ? const Color(0xFFFF4444).withValues(alpha: 0.9)
                  : const Color.fromARGB(207, 241, 233, 141),
              border: Border.all(
                color: controller.isUrgent
                    ? Colors.red
                    : const Color.fromARGB(218, 219, 183, 38),
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              controller.display,
              style: GoogleFonts.boogaloo(
                color: controller.isUrgent
                    ? Colors.white
                    : const Color.fromARGB(255, 82, 66, 34),
                fontSize: 20,
                letterSpacing: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}