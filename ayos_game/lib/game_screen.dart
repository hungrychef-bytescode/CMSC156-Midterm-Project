import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:ui';

import 'game_config.dart';
import 'game_components.dart';

class GameScreen extends StatefulWidget {
  final LevelConfig config;
  const GameScreen({super.key, required this.config});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {

  // ── State ─────────────────────────────────────────────────────────
  late int timeLeft;
  int countdown = 5;
  bool gameStarted = false;
  bool countdownRunning = true;
  bool hasGuessed = false;
  bool gameOver = false;
  String? hintMessage;

  Timer? gameTimer;
  Timer? countdownTimer;

  // ── Item data ─────────────────────────────────────────────────────
  late List<Map<String, String>> correctOrder;
  late List<Map<String, String>> playerOrder;

  // ── Animations ────────────────────────────────────────────────────
  late AnimationController _countdownPulse;
  late AnimationController _timerShake;
  late AnimationController _hintSlide;
  late Animation<double> _hintAnim;
  late Animation<double> _countdownScale;
  late Animation<Offset> _shakeAnim;

  // ── Lifecycle ─────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    timeLeft = widget.config.totalTime;

    _countdownPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _countdownScale = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _countdownPulse, curve: Curves.easeInOut),
    );

    _timerShake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = TweenSequence<Offset>([
      TweenSequenceItem(tween: Tween(begin: Offset.zero, end: const Offset(0.015, 0)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: const Offset(0.015, 0), end: const Offset(-0.015, 0)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: const Offset(-0.015, 0), end: Offset.zero), weight: 1),
    ]).animate(CurvedAnimation(parent: _timerShake, curve: Curves.easeInOut));

    _hintSlide = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _hintAnim = CurvedAnimation(parent: _hintSlide, curve: Curves.easeOut);

    _setupItems();
    _startCountdown();
  }

  // ── Setup ─────────────────────────────────────────────────────────
  void _setupItems() {
    final shuffled = List<Map<String, String>>.from(widget.config.allItems)..shuffle();
    correctOrder = shuffled.take(widget.config.itemCount).toList();
    playerOrder = List<Map<String, String>>.from(correctOrder)..shuffle();
    while (_isCorrect() && playerOrder.length > 1) {
      playerOrder.shuffle();
    }
  }

  // ── Countdown ─────────────────────────────────────────────────────
  void _startCountdown() {
    countdown = 5;
    countdownRunning = true;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => countdown--);
      if (countdown <= 0) {
        t.cancel();
        setState(() => countdownRunning = false);
        _startGame();
      }
    });
  }

  // ── Game Timer ────────────────────────────────────────────────────
  void _startGame() {
    setState(() => gameStarted = true);
    gameTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => timeLeft--);
      if (timeLeft <= 10) _timerShake.forward(from: 0);
      if (timeLeft <= 0) {
        t.cancel();
        _triggerGameOver();
      }
    });
  }

  void _triggerGameOver() {
    setState(() { gameOver = true; gameStarted = false; });
    _showLoseDialog();
  }

  // ── Game Logic ────────────────────────────────────────────────────
  bool _isCorrect() {
    for (int i = 0; i < correctOrder.length; i++) {
      if (playerOrder[i]['id'] != correctOrder[i]['id']) return false;
    }
    return true;
  }

  int _countCorrectPositions() {
    int hits = 0;
    for (int i = 0; i < correctOrder.length; i++) {
      if (playerOrder[i]['id'] == correctOrder[i]['id']) hits++;
    }
    return hits;
  }

  void _onGuess() {
    if (!gameStarted || gameOver) return;

    if (hasGuessed) {
      setState(() { hasGuessed = false; hintMessage = null; });
      _hintSlide.reverse();
      return;
    }

    if (_isCorrect()) {
      gameTimer?.cancel();
      setState(() { gameOver = true; gameStarted = false; });
      _showWinDialog();
      return;
    }

    final hits = _countCorrectPositions();
    final msg = switch (hits) {
      0 => "walang tama :(",
      1 => "isa ang tama!",
      2 => "dalawa ang tama!",
      _ => "$hits ang tama!",
    };

    setState(() { hasGuessed = true; hintMessage = msg; });
    _hintSlide.forward(from: 0);
  }

  void _swapItems(int from, int to) {
    if (!gameStarted || gameOver || from == to) return;
    setState(() {
      final tmp = playerOrder[from];
      playerOrder[from] = playerOrder[to];
      playerOrder[to] = tmp;
      hasGuessed = false;
      hintMessage = null;
    });
    _hintSlide.reverse();
  }

  // ── Helpers ───────────────────────────────────────────────────────
  String get timerDisplay {
    final m = (timeLeft ~/ 60).toString().padLeft(2, '0');
    final s = (timeLeft % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  bool get isUrgent => timeLeft <= 10 && gameStarted;

  // ── Dialogs ───────────────────────────────────────────────────────
  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameDialog(
        title: "You guessed all items correctly!",
        actions: [PillBtn(label: "Back to Menu", onTap: _goHome)],
      ),
    );
  }

  void _showLoseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameDialog(
        title: "Time's Up!",
        subtitle: "Better luck next time.",
        correctOrder: correctOrder,
        actions: [
          PillBtn(label: "Back to Menu", onTap: _goHome),
          PillBtn(label: "Try Again",    onTap: _restart),
        ],
      ),
    );
  }

  void _showExitDialog() {
    if (gameOver) { _goHome(); return; }
    showDialog(
      context: context,
      builder: (ctx) => GameDialog(
        title: "Are you sure you want to exit the game?",
        subtitle: "Current progress will not be saved",
        actions: [
          PillBtn(label: "Continue Playing", onTap: () => Navigator.of(ctx).pop()),
          PillBtn(label: "Exit Game",         onTap: _goHome),
        ],
      ),
    );
  }

  // ── Navigation ────────────────────────────────────────────────────
  void _goHome() {
    gameTimer?.cancel();
    countdownTimer?.cancel();
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  void _restart() {
    Navigator.of(context).pop();
    gameTimer?.cancel();
    countdownTimer?.cancel();
    setState(() {
      timeLeft = widget.config.totalTime;
      hasGuessed = false;
      hintMessage = null;
      gameOver = false;
      gameStarted = false;
      countdownRunning = true;
    });
    _hintSlide.reverse();
    _setupItems();
    _startCountdown();
  }

  // ── Dispose ───────────────────────────────────────────────────────
  @override
  void dispose() {
    gameTimer?.cancel();
    countdownTimer?.cancel();
    _countdownPulse.dispose();
    _timerShake.dispose();
    _hintSlide.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: const Color(0xFF382507),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 249, 199, 90)),
          onPressed: _showExitDialog,
        ),
        shape: const Border(
          bottom: BorderSide(color: Color.fromARGB(255, 255, 221, 0), width: 2.5),
        ),
        title: Transform.translate(
          offset: const Offset(-10, 0),
          child: Text(
            "Level: ${widget.config.level}",
            style: GoogleFonts.boogaloo(
              color: const Color.fromARGB(255, 249, 199, 90),
              fontSize: 30,
              letterSpacing: 3,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(child: _buildTimer()),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background
            Image.asset(
              "assets/images/maingame156.jpg",
              fit: BoxFit.cover,
              alignment: const Alignment(0, 2),
            ),
            // Blur overlay
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 2),
              child: Container(color: Colors.black.withOpacity(0.1)),
            ),

            // Hint bubble
            if (hintMessage != null)
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: FadeTransition(
                    opacity: _hintAnim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.5),
                        end: Offset.zero,
                      ).animate(_hintAnim),
                      child: HintBubble(message: hintMessage!),
                    ),
                  ),
                ),
              ),

            // Box image
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: const Offset(0, 150),
                child: Image.asset("assets/images/box.png", width: 450),
              ),
            ),

            // Footer bar
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: const Offset(0, 25),
                child: Container(width: 500, height: 100, color: const Color(0xFF382507)),
              ),
            ),

            // Mystery items (bottom row — hidden)
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 67),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: List.generate(
            //         correctOrder.length,
            //         (_) => Image.asset(
            //           widget.config.mysteryAsset,
            //           width: widget.config.itemWidth,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            // Player items (top row — draggable)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 265),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(playerOrder.length, (index) {
                    return DragTarget<int>(
                      onWillAcceptWithDetails: (d) => d.data != index,
                      onAcceptWithDetails: (d) => _swapItems(d.data, index),
                      builder: (context, candidates, _) {
                        final isTarget = candidates.isNotEmpty;
                        return Draggable<int>(
                          data: index,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Transform.scale(
                              scale: 1.08,
                              child: Image.asset(
                                playerOrder[index]['asset']!,
                                width: widget.config.itemWidth,
                              ),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.25,
                            child: Image.asset(
                              playerOrder[index]['asset']!,
                              width: widget.config.itemWidth,
                            ),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isTarget ? Colors.yellowAccent : Colors.transparent,
                                width: 2.5,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: isTarget
                                  ? [BoxShadow(color: Colors.yellow.withOpacity(0.5), blurRadius: 12, spreadRadius: 2)]
                                  : [],
                            ),
                            child: Image.asset(
                              playerOrder[index]['asset']!,
                              width: widget.config.itemWidth,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),

            // Action button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 38),
                child: ActionButton(
                  label: hasGuessed ? "Subukan ulit" : "Hulaan na!",
                  enabled: gameStarted && !gameOver,
                  onTap: _onGuess,
                ),
              ),
            ),

            // Countdown overlay
            if (countdownRunning) _buildCountdownOverlay(),
          ],
        ),
      ),
    );
  }

  // ── Timer widget ──────────────────────────────────────────────────
  Widget _buildTimer() {
    return SlideTransition(
      position: _shakeAnim,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: isUrgent
              ? const Color(0xFFFF4444).withOpacity(0.9)
              : const Color.fromARGB(207, 241, 233, 141),
          border: Border.all(
            color: isUrgent ? Colors.red : const Color.fromARGB(218, 219, 183, 38),
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          timerDisplay,
          style: GoogleFonts.boogaloo(
            color: isUrgent ? Colors.white : const Color.fromARGB(255, 82, 66, 34),
            fontSize: 20,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  // ── Countdown overlay ─────────────────────────────────────────────
  Widget _buildCountdownOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
      child: Container(
        color: Colors.black.withOpacity(0.25),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
            decoration: BoxDecoration(
              color: const Color.fromARGB(235, 241, 233, 141),
              border: Border.all(color: const Color.fromARGB(218, 219, 183, 38), width: 3),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Guess the correct order of items!",
                  style: GoogleFonts.boogaloo(
                    color: const Color(0xFF5A4222),
                    fontSize: 17,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "the game will start in...",
                  style: GoogleFonts.nunito(
                    color: const Color(0xFF7A6040),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ScaleTransition(
                  scale: _countdownScale,
                  child: Text(
                    "$countdown",
                    style: GoogleFonts.boogaloo(
                      color: const Color(0xFFC8860A),
                      fontSize: 80,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}