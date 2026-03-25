import 'package:flutter/material.dart';

import 'package:ayos_game/routes.dart';

class GameNavigation {
  static void goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  static void goToLevel(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.level,
      (route) => false,
    );
  }
}