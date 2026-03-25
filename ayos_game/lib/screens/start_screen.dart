import 'package:flutter/material.dart';
import 'package:ayos_game/routes.dart';
import 'package:ayos_game/assets.dart';
import 'package:ayos_game/widgets/play_button.dart';

/* 
  class StartScreen - first screen of the game
  - contains Ayos! (game title)
  and play now button
*/
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            //background image
            Image.asset(
              Assets.homeBg,
              fit: BoxFit.cover,
              alignment: const Alignment(0, 2), 
            ),
            
            Column(
              children: [
                //TOP - Ayos! title
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Image.asset(Assets.title),
                ),

                const Spacer(),

                //Play Now button
                Padding(
                  padding: const EdgeInsets.only(bottom: 340),
                  child: PlayButton(
                    onTap: () => Navigator.pushNamed(context, Routes.level),
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