import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:ui';

class EasyScreen extends StatefulWidget {
  const EasyScreen({super.key});

  @override
  State<EasyScreen> createState() => _EasyScreenState();
}

class _EasyScreenState extends State<EasyScreen> {
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
        backgroundColor: const Color.fromARGB(255, 56, 37, 7),
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
            // Box image
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: const Offset(0, 110),
                child: Image.asset(
                  "assets/images/box.png",
                  width: 430,
                ),
              ),
            ),
            // Footer
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: const Offset(0, 25),
                child: Container(
                  width: 500,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 56, 37, 7),
                  ),
                ),
              ),
            ),
            // Timer text
            Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(0, -310),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(207, 241, 233, 141),
                    border: Border.all(
                      color: const Color.fromARGB(218, 219, 183, 38),
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Time Left: $gameTime",
                    style: GoogleFonts.boogaloo(
                      color: const Color.fromARGB(255, 82, 66, 34),
                      fontSize: 20,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
            ),

            // Silhouette Bottles
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 67),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/bottle_myst.png", width: 150),
                    Image.asset("assets/images/bottle_myst.png", width: 150),
                    Image.asset("assets/images/bottle_myst.png", width: 150),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}