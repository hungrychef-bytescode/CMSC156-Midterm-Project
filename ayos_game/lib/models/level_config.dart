
// LEVEL CONFIGURATIONS FOR DATA ________________________________

import 'package:ayos_game/models/level.dart';
import 'package:ayos_game/models/game_item.dart';

class LevelConfig {
  final Level level;
  final int totalTime;
  final int itemCount;
  final int reward;
  final List<GameItem> allItems;
  final double itemWidth;

  const LevelConfig({
    required this.level,
    required this.totalTime,
    required this.itemCount,
    required this.reward,
    required this.allItems,
    required this.itemWidth,
  });
}