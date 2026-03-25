import 'package:flutter/material.dart';

class LevelButton extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;

  const LevelButton({
    super.key,
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 280,
        child: Image.asset(asset),
      ),
    );
  }
}