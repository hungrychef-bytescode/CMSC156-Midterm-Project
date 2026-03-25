import 'package:flutter/material.dart';
import 'package:ayos_game/screens/screens.dart';
import "package:ayos_game/utils/helper.dart";
import "package:ayos_game/routes.dart";
import "package:ayos_game/models/level.dart";

//start app and run home widget
void main() => runApp(const Home());


/*
  class Home: root widget of the game
  - contains the App Configuration (materialapp)
  - initial route, static and dynamic routes.
  - builder for scaling screen
*/
class Home extends StatelessWidget {
  const Home({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: Routes.start,
      
      routes: {
      },

      onGenerateRoute: (settings) {
        if (settings.name == Routes.game) {
          final level = settings.arguments as Level? ?? Level.easy;
          final config = configForLevel(level);

          return MaterialPageRoute(builder: (_) => GameScreen(config: config));
        }
        
        //fallback
        return MaterialPageRoute(builder: (_) => const StartScreen());
      },

      builder: (context, child) {
        return Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 450,
              height: 800,
              child: child ?? const SizedBox(),
            ),
          ),
        );
      },
    );
  }
}