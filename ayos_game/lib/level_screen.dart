import 'package:flutter/material.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level Screen"),
      ),
      body: SelectLevel(),
    );
  }
}

class SelectLevel extends StatelessWidget {
  const SelectLevel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/gameScreen'), 
            label: Text("Level 1"))
        ]
      )
    );
  }
}