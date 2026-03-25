import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Hint Bubble ───────────────────────────────────────────────────────
class HintBubble extends StatelessWidget {
  final String message;
  const HintBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEBFF),
        border: Border.all(color: const Color(0xFF9B97D4), width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        message,
        style: GoogleFonts.boogaloo(
          color: const Color(0xFF2E2B5F),
          fontSize: 17,
          letterSpacing: 1,
        ),
      ),
    );
  }
}