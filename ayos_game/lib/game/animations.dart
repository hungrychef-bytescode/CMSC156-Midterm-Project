
// ALL ANIMATION CONTROLLERS & TWEENS ________________________________

import 'package:flutter/material.dart';

class GameAnimations {
  late AnimationController countdownPulse;
  late AnimationController timerShake;
  late AnimationController hintSlide;

  late Animation<double> countdownScale;
  late Animation<Offset> shakeAnim;
  late Animation<double> hintFade;
  late Animation<Offset> hintSlideAnim;

  void init(TickerProvider vsync) {

    // Countdown pulse
    countdownPulse = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    countdownScale = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: countdownPulse, curve: Curves.easeInOut),
    );

    // Timer shake
    timerShake = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 400),
    );

    shakeAnim = TweenSequence<Offset>([
      TweenSequenceItem(tween: Tween(begin: Offset.zero, end: const Offset(0.015, 0)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: const Offset(0.015, 0), end: const Offset(-0.015, 0)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: const Offset(-0.015, 0), end: Offset.zero), weight: 1),
    ]).animate(CurvedAnimation(parent: timerShake, curve: Curves.easeInOut));

    // Hint animation
    hintSlide = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 350),
    );

    hintFade = CurvedAnimation(parent: hintSlide, curve: Curves.easeOut);

    hintSlideAnim = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(hintFade);
  }

  void dispose() {
    countdownPulse.dispose();
    timerShake.dispose();
    hintSlide.dispose();
  }
}