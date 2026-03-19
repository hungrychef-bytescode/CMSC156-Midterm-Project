class LevelConfig { //level data
  final String level;
  final int totalTime;
  final int itemCount;
  final int reward;
  final List<Map<String, String>> allItems;
  final String mysteryAsset;
  final double itemWidth;

  const LevelConfig({
    required this.level,
    required this.totalTime,
    required this.itemCount,
    required this.reward,
    required this.allItems,
    required this.mysteryAsset,
    required this.itemWidth,
  });
}

// ── Easy ──────────────────────────────────────────────────────────────
final easyConfig = LevelConfig(
  level: "Easy",
  totalTime: 60,
  itemCount: 3,
  reward: 5,
  itemWidth: 130,
  mysteryAsset: "assets/images/bottle_myst.png",
  allItems: [
    {"id": "green",  "asset": "assets/images/c2green.webp"},
    {"id": "yellow", "asset": "assets/images/c2yellow.webp"},
    {"id": "red",    "asset": "assets/images/c2red.webp"},
  ],
);

// ── Average ───────────────────────────────────────────────────────────
final averageConfig = LevelConfig(
  level: "Average",
  totalTime: 45,
  itemCount: 4,
  reward: 10,
  itemWidth: 100,
  mysteryAsset: "assets/images/cheesering.png",
  allItems: [
    {"id": "green",  "asset": "assets/images/cheesering.png"},
    {"id": "yellow", "asset": "assets/images/cheezit.png"},
    {"id": "red",    "asset": "assets/images/chizcurls.png"},
    {"id": "blue",   "asset": "assets/images/dingdong.png"},
  ],
);

// ── Difficult ─────────────────────────────────────────────────────────
final difficultConfig = LevelConfig(
  level: "Difficult",
  totalTime: 30,
  itemCount: 5,
  reward: 15,
  itemWidth: 80,
  mysteryAsset: "assets/images/elektrons.png",
  allItems: [
    {"id": "green",  "asset": "assets/images/skimmers.png"},
    {"id": "yellow", "asset": "assets/images/elektrons.png"},
    {"id": "red",    "asset": "assets/images/clovers.png"},
    {"id": "blue",   "asset": "assets/images/ugyon.png"},
    {"id": "purple", "asset": "assets/images/redbolts.png"},
  ],
);

// ── Helper ────────────────────────────────────────────────────────────
LevelConfig configForLevel(String level) => switch (level) {
  "Average"   => averageConfig,
  "Difficult" => difficultConfig,
  _           => easyConfig,
};