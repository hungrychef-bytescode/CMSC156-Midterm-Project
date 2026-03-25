import 'package:ayos_game/models/level.dart';
import 'package:ayos_game/models/level_config.dart';
import 'package:ayos_game/data/level_data.dart';

final Map<Level, LevelConfig> levelConfigs = {
  Level.easy: easyConfig,
  Level.average: averageConfig,
  Level.difficult: difficultConfig,
};

LevelConfig configForLevel(Level level) {
  return levelConfigs[level] ?? easyConfig;
}

String getLevelName(Level level) {
  switch (level) {
    case Level.easy:
      return "Easy";
    case Level.average:
      return "Average";
    case Level.difficult:
      return "Difficult";
  }
}