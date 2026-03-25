
// lEVEL CONFIGURATIONS AND DATA (ITEMS,TIME,REWARDS) ________________________________

import '../models/level_config.dart';
import 'package:ayos_game/models/level.dart';
import 'package:ayos_game/assets.dart';
import 'package:ayos_game/models/game_item.dart';

//Easy
final easyConfig = LevelConfig(
  level: Level.easy,
  totalTime: 60,
  itemCount: 3,
  reward: 5,
  itemWidth: 130,
  allItems: [
    GameItem(id: "c2 Green", asset: Assets.c2Green),
    GameItem(id: "c2 Yellow", asset: Assets.c2Yellow),
    GameItem(id: "c2 Red", asset: Assets.c2Red )
  ],
);

//Average
final averageConfig = LevelConfig(
  level: Level.average,
  totalTime: 45,
  itemCount: 4,
  reward: 10,
  itemWidth: 100,
  allItems: [
    GameItem(id: "cheese ring", asset: Assets.cheeseRing),
    GameItem(id: "cheez it", asset: Assets.cheezIt),
    GameItem(id: "chiz curls", asset: Assets.chizCurls),
    GameItem(id: "dingdong" , asset: Assets.dingdong),
  ],
);

//Difficult
final difficultConfig = LevelConfig(
  level: Level.difficult,
  totalTime: 30,
  itemCount: 5,
  reward: 15,
  itemWidth: 80,
  allItems: [
    GameItem(id: "skimmers" , asset: Assets.skimmers),
    GameItem(id: "elektrons" , asset: Assets.elektrons),
    GameItem(id: "clovers" , asset: Assets.clovers),
    GameItem(id: "ugyon" , asset: Assets.ugyon),
    GameItem(id: "redbolts" , asset: Assets.redbolts),
  ],
);