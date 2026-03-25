import 'package:flutter/material.dart';
import 'package:ayos_game/assets.dart';

class PlayButton extends StatelessWidget {
  final VoidCallback onTap;
  
  const PlayButton({super.key, required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 250,
        child: Image.asset(Assets.playButton),
      ),
    );
  }
}