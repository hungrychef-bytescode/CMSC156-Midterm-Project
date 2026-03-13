import 'package:flutter/material.dart';
import 'dart:ui';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/homescreen156.jpg",
              fit: BoxFit.cover,
              alignment: const Alignment(0, 2),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            const SelectLevel(),
          ],
        ),
      ),
    );
  }
}

class SelectLevel extends StatelessWidget {
  const SelectLevel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Back arrow
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 16),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 251, 255, 0), size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),

        const Spacer(),

        // Select a Level image
        Transform.translate(
          offset: const Offset(0, -50), // negative = up, positive = down
          child: SizedBox(
            width: 600,
            child: Image.asset("assets/images/selectLevel.png"),
          ),
        ),

        // Easy button
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/easyScreen', arguments: "Easy"),
          child: SizedBox(
            width: 280,
            child: Image.asset("assets/images/easy.png"),
          ),
        ),

        const SizedBox(height: 16),

        // Average button
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/averageScreen', arguments: "Average"),
          child: SizedBox(
            width: 280,
            child: Image.asset("assets/images/average.png"),
          ),
        ),

        const SizedBox(height: 16),

        // Difficult button
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/difficultScreen', arguments: "Difficult"),
          child: SizedBox(
            width: 280,
            child: Image.asset("assets/images/difficult.png"),
          ),
        ),

        const Spacer(),
      ],
    );
  }
}