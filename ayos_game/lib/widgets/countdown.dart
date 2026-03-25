import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayos_game/game/countdown_controller.dart';

class CountdownOverlay extends StatelessWidget {
  final CountdownController controller;
  final Animation<double> scaleAnimation;

  const CountdownOverlay({
    super.key,
    required this.controller,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        if (!controller.isRunning) return const SizedBox();

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
          child: Container(
            color: Colors.black.withValues(alpha: 0.25),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(235, 241, 233, 141),
                  border: Border.all(
                    color: const Color.fromARGB(218, 219, 183, 38),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Guess the correct order of items!",
                      style: GoogleFonts.boogaloo(
                        color: const Color(0xFF5A4222),
                        fontSize: 17,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "the game will start in...",
                      style: GoogleFonts.nunito(
                        color: const Color(0xFF7A6040),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ScaleTransition(
                      scale: scaleAnimation,
                      child: Text(
                        "${controller.countdown}",
                        style: GoogleFonts.boogaloo(
                          color: const Color(0xFFC8860A),
                          fontSize: 80,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}