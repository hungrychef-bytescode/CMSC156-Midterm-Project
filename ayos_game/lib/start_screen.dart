import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayos!"),
        centerTitle: true,
      ),
      body: StartGame(),
    );
  }
}

class StartGame extends StatelessWidget {
  const StartGame ({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/levelScreen'), 
            label: Text("Play Game"))
        ]
      )
    );
  }
}