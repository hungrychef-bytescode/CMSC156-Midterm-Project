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
            color: Colors.black.withOpacity(0.18),
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

// ── Action Button ─────────────────────────────────────────────────────
class ActionButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF5D060), Color(0xFFD4A020)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: const Color(0xFFC89A10), width: 2.5),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(color: Color(0xFF7A5C08), offset: Offset(0, 4), blurRadius: 0),
              BoxShadow(color: Color(0x44000000), offset: Offset(0, 6), blurRadius: 10),
            ],
          ),
          child: Text(
            label,
            style: GoogleFonts.boogaloo(
              color: const Color(0xFF4A3000),
              fontSize: 22,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Game Dialog (lavender card) ───────────────────────────────────────
class GameDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final List<Map<String, String>>? correctOrder;

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
                    child: Image.asset(item['asset']!, width: 50),
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

// ── Pill Button (gold, used inside dialogs) ───────────────────────────
class PillBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const PillBtn({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF7D45A), Color(0xFFD4A020)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: const Color(0xFFC89A10), width: 1.8),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Color(0xFF7A5C08), offset: Offset(0, 3), blurRadius: 0),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.boogaloo(
            fontSize: 14,
            fontWeight: FontWeight.w200,
            color: const Color(0xFF4A3000),
          ),
        ),
      ),
    );
  }
}