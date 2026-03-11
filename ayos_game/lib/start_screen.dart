import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

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
              alignment: Alignment(0, 2), 
            ),

            Column(
              children: [
                // TOP - Ayos! title
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Image.asset("assets/images/ayosTitle.png"),
                ),

                const Spacer(),

                // MIDDLE-BOTTOM - Play Now button
              Padding(
                padding: const EdgeInsets.only(bottom: 340),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/levelScreen'),
                  child: SizedBox(
                    width: 250,  // adjust size here
                    child: Image.asset("assets/images/playButton.png"),
                  ),
                ),
              ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}