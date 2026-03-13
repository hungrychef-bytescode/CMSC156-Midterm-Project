import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:ui';

class DifficultScreen extends StatefulWidget {
  const DifficultScreen({super.key});

  @override
  State<DifficultScreen> createState() => _DifficultScreenState();
}

class _DifficultScreenState extends State<DifficultScreen> {
  int gameTime = 0;
  int items = 0;

  int countdown = 5;
  bool gameStarted = false;

  Timer? timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final level = ModalRoute.of(context)!.settings.arguments as String;

    if (level == "Easy") {
      gameTime = 60;
      items = 3;
    } else if (level == "Average") {
      gameTime = 45;
      items = 4;
    } else if (level == "Difficult") {
      gameTime = 30;
      items = 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: const Color.fromARGB(255, 90, 59, 12),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 249, 199, 90)),
        shape: const Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 255, 221, 0),
            width: 2.5,
          ),
        ),
        title: Transform.translate(
          offset: const Offset(-10, 0),
          child: Text(
            "Level: $level",
            style: GoogleFonts.boogaloo(
              color: const Color.fromARGB(255, 249, 199, 90),
              fontSize: 30,
              letterSpacing: 3,
            ),
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              "assets/images/maingame156.jpg",
              fit: BoxFit.cover,
              alignment: const Alignment(0, 2),
            ),
            // Blur layer
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 2),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
            // Box image - adjust Offset(0, -100) to move further up
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: const Offset(0, 110), // increase number to move more up
                child: Image.asset(
                  "assets/images/box.png",
                  width: 430,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [Text("")],
              ),
            ),
          ],
        ),
      ),
    );
  }
}