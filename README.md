# 🎮 Ayos! — A Filipino Snack Sorting Game

**Ayos!** is a Flutter-based mobile puzzle game where players must arrange shuffled Filipino snack items into the correct order before time runs out. Built as a midterm project for **CMSC 156**.

---

## 👥 Contributors

Developed by *Janiola AM & Verde M* for CMSC 156 — Midterm Project.


## 📱 Screens

| Screen | Description |
|---|---|
| **Start Screen** | Displays the game title and a "Play Now" button |
| **Level Screen** | Lets the player choose a difficulty level |
| **Game Screen** | The main gameplay — drag, sort, and guess! |

---

## 🕹️ How to Play

1. Launch the app and tap **Play Now**
2. Select a difficulty: **Easy**, **Average**, or **Difficult**
3. A 5-second countdown begins before the game starts
4. The items on screen are **shuffled** — drag and swap them to arrange them in the correct order
5. Tap **Guess** when you think the order is correct
   - ✅ Correct → You win!
   - ❌ Wrong → A hint appears telling you how many items are in the right position (in Filipino!)
6. Arrange all items correctly before the timer hits **0:00** to win

---

## 🏆 Difficulty Levels

| Level | Items | Time Limit | Reward |
|---|---|---|---|
| Easy | 3 | 60 seconds | 5 pts |
| Average | 4 | 45 seconds | 10 pts |
| Difficult | 5 | 30 seconds | 15 pts |

### 🍿 Game Items per Level

**Easy** — C2 Drinks
- C2 Green, C2 Yellow, C2 Red

**Average** — Cheese Snacks
- Cheese Ring, Cheez It, Chiz Curls, Dingdong

**Difficult** — Classic Filipino Biscuits & Snacks
- Skimmers, Elektrons, Clovers, Ugyon, Redbolts

---

## 📁 Project Structure

```
lib/
├── main.dart                   # App entry point & routing
├── assets.dart                 # Centralized asset path constants
├── routes.dart                 # Named route constants
│
├── data/
│   └── level_data.dart         # Level configurations (items, time, rewards)
│
├── models/
│   ├── level.dart              # Level enum (easy, average, difficult)
│   ├── level_config.dart       # LevelConfig data class
│   └── game_item.dart          # GameItem data class (id + asset)
│
├── game/
│   ├── game.dart               # Barrel export for game controllers
│   ├── game_controller.dart    # Core game logic (shuffle, swap, win check)
│   ├── game_timer_controller.dart  # Countdown game timer
│   ├── countdown_controller.dart   # Pre-game 5-second countdown
│   ├── hint_controller.dart    # Hint messages after wrong guess
│   ├── animations.dart         # All animation controllers & tweens
│   ├── game_view.dart          # Main game UI layout (StatelessWidget)
│   ├── game_appbar.dart        # Top bar with level name & timer
│   ├── game_drag.dart          # Drag-and-swap item board
│   ├── game_footer.dart        # Bottom area with Guess button
│   └── background.dart         # Game background widget
│
├── screens/
│   ├── screens.dart            # Barrel export for screens
│   ├── start_screen.dart       # Home/start screen
│   ├── level_screen.dart       # Level selection screen
│   └── game_screen.dart        # Stateful game screen (controller setup)
│
├── widgets/
│   ├── widgets.dart            # Barrel export for widgets
│   ├── action_button.dart      # Generic action button
│   ├── countdown.dart          # Countdown overlay widget
│   ├── game_dialog.dart        # Win/Lose dialog
│   ├── game_timer.dart         # Timer display widget
│   ├── hint_bubble.dart        # Animated hint message bubble
│   ├── level_button.dart       # Level selection button
│   ├── pill_button.dart        # Pill-shaped button (used in dialogs)
│   └── play_button.dart        # Start screen play button
│
└── utils/
    └── helper.dart             # Utility functions (e.g., configForLevel)
```

---

## 🏗️ Architecture

The game follows a **controller-view separation** pattern using Flutter's `ChangeNotifier` and `AnimatedBuilder`:

- **Controllers** (`ChangeNotifier`) hold state and business logic
- **GameView** is a pure `StatelessWidget` that receives all controllers as parameters
- **GameScreen** is the `StatefulWidget` that initializes controllers and wires everything together via `AnimatedBuilder` + `Listenable.merge`

### Controllers

| Controller | Responsibility |
|---|---|
| `GameController` | Shuffle setup, item swapping, win/loss detection, hint counting |
| `GameTimerController` | Tracks remaining time, triggers urgent state at ≤10s |
| `CountdownController` | Manages the 5-second pre-game countdown |
| `HintController` | Stores and displays hint messages in Filipino after a wrong guess |

### Animations

| Animation | Trigger |
|---|---|
| `countdownScale` (pulse) | Plays during pre-game countdown |
| `shakeAnim` | Fires on the timer when ≤10 seconds remain |
| `hintFade` + `hintSlideAnim` | Slides the hint bubble in from the top |

---

## ⚙️ Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- Android Studio / VS Code with Flutter extension
- An Android or iOS device/emulator

### Installation

```bash
# Clone the repository
git clone https://github.com/hungrychef-bytescode/CMSC156-Midterm-Project.git

# Navigate to the project directory
cd CMSC156-Midterm-Project

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## 📄 License

This project was made for academic purposes.
