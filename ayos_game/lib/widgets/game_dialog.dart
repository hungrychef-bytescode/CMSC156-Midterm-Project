import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayos_game/models/game_item.dart';

// ── Game Dialog (lavender card) ───────────────────────────────────────
class GameDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final List<GameItem>? correctOrder;

  const GameDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.correctOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF9B97D4), width: 5),
      ),
      backgroundColor: const Color(0xFFC8C6E8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.boogaloo(
                fontSize: 17,
                color: const Color.fromARGB(255, 81, 76, 165),
                height: 1.3,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: GoogleFonts.boogaloo(
                  fontSize: 13,
                  color: const Color(0xFF555370),
                ),
              ),
            ],

            // Correct order images
            if (correctOrder != null && correctOrder!.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                "Correct order:",
                style: GoogleFonts.boogaloo(
                  fontSize: 13,
                  color: const Color(0xFF555370),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: correctOrder!.map((item) =>
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Image.asset(item.asset, width: 50),
                  ),
                ).toList(),
              ),
            ],

            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: actions!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}