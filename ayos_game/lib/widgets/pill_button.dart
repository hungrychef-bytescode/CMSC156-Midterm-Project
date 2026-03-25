import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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