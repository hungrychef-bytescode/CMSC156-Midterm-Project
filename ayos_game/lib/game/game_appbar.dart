
// TOP BAR WITH LEVEL & TIMER ________________________________

import 'package:flutter/material.dart';
import 'package:ayos_game/game/game_timer_controller.dart';
import 'package:ayos_game/models/level.dart';
import 'package:ayos_game/utils/helper.dart';
import 'package:google_fonts/google_fonts.dart';

class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Level level;
  final GameTimerController timer;
  final Animation<Offset> shake;

  const GameAppBar({
    super.key,
    required this.level,
    required this.timer,
    required this.shake,
  });

 @override
Widget build(BuildContext context) {
  return AppBar(
    toolbarHeight: 60,
    backgroundColor: const Color(0xFF382507),

    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Color.fromARGB(255, 249, 199, 90),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),

    shape: const Border(
      bottom: BorderSide(
        color: Color.fromARGB(255, 255, 221, 0),
        width: 2.5,
      ),
    ),

    title: Transform.translate(
      offset: const Offset(-10, 0),
      child: Text(
        "Level: ${getLevelName(level)}",
        style: GoogleFonts.boogaloo(
          color: const Color.fromARGB(255, 249, 199, 90),
          fontSize: 30,
          letterSpacing: 3,
        ),
      ),
    ),

    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Center(
          child: _buildStyledTimer(), // 👈 we define this next
        ),
      ),
    ],
  );
}

Widget _buildStyledTimer() {
  return AnimatedBuilder(
    animation: timer,
    builder: (_, __) {
      return SlideTransition(
        position: shake,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),

          decoration: BoxDecoration(
            color: timer.isUrgent
                ? const Color(0xFFFF4444).withOpacity(0.9)
                : const Color.fromARGB(207, 241, 233, 141),

            border: Border.all(
              color: timer.isUrgent
                  ? Colors.red
                  : const Color.fromARGB(218, 219, 183, 38),
              width: 2.5,
            ),

            borderRadius: BorderRadius.circular(10),
          ),

          child: Text(
            timer.display,
            style: GoogleFonts.boogaloo(
              color: timer.isUrgent
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

  @override
  Size get preferredSize => const Size.fromHeight(60);
}