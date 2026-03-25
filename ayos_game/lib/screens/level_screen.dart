import 'package:flutter/material.dart';

import 'package:ayos_game/assets.dart';
import 'package:ayos_game/models/level.dart';
import 'package:ayos_game/routes.dart';
import 'package:ayos_game/widgets/level_button.dart';
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
              Assets.homeBg,
              fit: BoxFit.cover,
              alignment: const Alignment(0, 2),
            ),

            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withValues(alpha: 0.2),
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
              icon: const Icon(
                Icons.arrow_back, 
                color: Color.fromARGB(255, 251, 255, 0), 
                size: 28
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),

        const Spacer(),

        // Select a Level image
        Transform.translate(
          offset: const Offset(0, -50),
          child: SizedBox(
            width: 600,
            child: Image.asset(Assets.selectLevel),
          ),
        ),

        //Easy button
        LevelButton(
          asset: Assets.easyLevel,
          onTap: () => Navigator.pushNamed(context, Routes.game, arguments: Level.easy,),
        ),

        const SizedBox(height: 16),
        
        //Average button
        LevelButton(
          asset: Assets.averageLevel,
          onTap: () => Navigator.pushNamed(context, Routes.game, arguments: Level.average,),
        ),

        const SizedBox(height: 16),

        //difficult button
        LevelButton(
          asset: Assets.difficultLevel,
          onTap: () => Navigator.pushNamed(context, Routes.game, arguments: Level.difficult,),
        ),

        const Spacer(),
      ],
    );
  }
}