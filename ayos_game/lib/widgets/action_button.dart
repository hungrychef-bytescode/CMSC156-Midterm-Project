import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Action Button

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