import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:ui';

class EasyScreen extends StatefulWidget {
  const EasyScreen({super.key});

  @override
  State<EasyScreen> createState() => _EasyScreenState();
}

class _EasyScreenState extends State<EasyScreen>
    with TickerProviderStateMixin {
  // ── Config ────────────────────────────────────────────────────────
  int totalTime = 60;
  int itemCount = 3;
  int reward = 5;
  String level = "Easy";

  // ── State ─────────────────────────────────────────────────────────
  int timeLeft = 60;
  int countdown = 5;
  bool gameStarted = false;
  bool countdownRunning = true;
  bool hasGuessed = false;
  bool gameOver = false;
  String? hintMessage;

  Timer? gameTimer;
  Timer? countdownTimer;

  // ── Bottle data ───────────────────────────────────────────────────
  final List<Map<String, String>> allBottles = [
    {"id": "green",  "asset": "assets/images/c2green.webp"},
    {"id": "yellow", "asset": "assets/images/c2yellow.webp"},
    {"id": "red",    "asset": "assets/images/c2red.webp"},
  ];

  late List<Map<String, String>> correctOrder;
  late List<Map<String, String>> playerOrder;

  // ── Drag state ────────────────────────────────────────────────────
  int? draggingIndex;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    level = ModalRoute.of(context)!.settings.arguments as String? ?? "Easy";
    _applyLevelConfig();
    _setupBottles();
    _startCountdown();
  }

  void _applyLevelConfig() {
    if (level == "Easy")      { totalTime = 60; itemCount = 3; reward = 5; }
    else if (level == "Average")   { totalTime = 45; itemCount = 4; reward = 10; }
    else if (level == "Difficult") { totalTime = 30; itemCount = 5; reward = 15; }
    timeLeft = totalTime;
  }

  void _setupBottles() {
    final shuffled = List<Map<String, String>>.from(allBottles)..shuffle();
    correctOrder = shuffled.take(itemCount).toList();
    playerOrder  = List<Map<String, String>>.from(correctOrder)..shuffle();
    // Ensure it's not already correct
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

  // ── Logic ─────────────────────────────────────────────────────────
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
      // "Subukan ulit" — reset to try again
      setState(() {
        hasGuessed = false;
        hintMessage = null;
      });
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
    String msg;
    if (hits == 0)      msg = "walang tama :(";
    else if (hits == 1) msg = "isa ang tama!";
    else if (hits == 2) msg = "dalawa ang tama!";
    else                msg = "$hits ang tama!";

    setState(() {
      hasGuessed = true;
      hintMessage = msg;
    });
    _hintSlide.forward(from: 0);
  }

  void _swapBottles(int from, int to) {
    if (!gameStarted || gameOver || from == to) return;
    setState(() {
      final tmp = playerOrder[from];
      playerOrder[from] = playerOrder[to];
      playerOrder[to] = tmp;
      // Reset guess state on swap
      hasGuessed = false;
      hintMessage = null;
    });
    _hintSlide.reverse();
  }

  // ── Timer display ─────────────────────────────────────────────────
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
      builder: (_) => _GameDialog(
        title: "🎉 You guessed all items correctly!",
        subtitle: "Earned reward: $reward pesos",
        subtitleColor: const Color(0xFFC8860A),
        actions: [
          _DialogBtn(label: "Back to Menu", onTap: _goHome, outlined: true),
          _DialogBtn(label: "Next Level",   onTap: _nextLevel),
        ],
      ),
    );
  }

  void _showLoseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _GameDialog(
        title: "⏰ Time's Up!",
        subtitle: "Better luck next time.",
        actions: [
          _DialogBtn(label: "Back to Menu", onTap: _goHome, outlined: true),
          _DialogBtn(label: "Try Again",    onTap: _restart),
        ],
      ),
    );
  }

  void _showExitDialog() {
    if (gameOver) { _goHome(); return; }
    showDialog(
      context: context,
      builder: (_) => _GameDialog(
        title: "Exit Game?",
        subtitle: "Are you sure you want to exit?\nCurrent progress will not be saved.",
        showClose: true,
        actions: [
          _DialogBtn(label: "Continue Playing", onTap: () => Navigator.pop(context)),
          _DialogBtn(label: "Exit Game",         onTap: _goHome, danger: true),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    bool bgMusic = true;
    bool sfx     = true;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => _GameDialog(
          title: "Settings",
          showClose: true,
          customContent: Column(
            children: [
              _SettingsRow(
                label: "Background Music",
                value: bgMusic,
                onChanged: (v) => setS(() => bgMusic = v),
              ),
              _SettingsRow(
                label: "Sound Effects",
                value: sfx,
                onChanged: (v) => setS(() => sfx = v),
              ),
              const SizedBox(height: 14),
              _DialogBtn(label: "OK", onTap: () => Navigator.pop(ctx)),
            ],
          ),
        ),
      ),
    );
  }

  void _goHome() {
    gameTimer?.cancel();
    countdownTimer?.cancel();
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  void _restart() {
    Navigator.of(context).pop(); // close dialog
    gameTimer?.cancel();
    countdownTimer?.cancel();
    setState(() {
      timeLeft = totalTime;
      hasGuessed = false;
      hintMessage = null;
      gameOver = false;
      gameStarted = false;
      countdownRunning = true;
    });
    _hintSlide.reverse();
    _setupBottles();
    _startCountdown();
  }

  void _nextLevel() {
    Navigator.of(context).pop();
    gameTimer?.cancel();
    countdownTimer?.cancel();
    final levels = ["Easy", "Average", "Difficult"];
    final next = levels[(levels.indexOf(level) + 1) % levels.length];
    Navigator.pushReplacementNamed(context, '/game', arguments: next);
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

  // ── BUILD ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: const Color(0xFF382507),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 249, 199, 90)),
          onPressed: _showExitDialog,
        ),
        shape: const Border(
          bottom: BorderSide(color: Color.fromARGB(255, 255, 221, 0), width: 2.5),
        ),
        title: Transform.translate(
          offset: const Offset(-10, 0),
          child: Text(
            "Level: $level",
            style: GoogleFonts.boogaloo(
              color: const Color.fromARGB(255, 249, 199, 90),
              fontSize: 30,
              letterSpacing: 3,
            ),
          ),
        ),
        actions: [
          // Timer in AppBar
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(child: _buildTimer()),
          ),
          // Settings menu
          IconButton(
            icon: const Icon(Icons.more_vert,
                color: Color.fromARGB(255, 249, 199, 90)),
            onPressed: _showSettingsDialog,
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
            // Blur
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
                      child: _HintBubble(message: hintMessage!),
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
                child: Container(
                  width: 500,
                  height: 100,
                  color: const Color(0xFF382507),
                ),
              ),
            ),

            // Mystery bottles (bottom row — fixed)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 67),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    correctOrder.length,
                    (_) => Image.asset(
                      "assets/images/bottle_myst.png",
                      width: 130,
                    ),
                  ),
                ),
              ),
            ),

            // Player bottles (top row — draggable)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 265),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(playerOrder.length, (index) {
                    return DragTarget<int>(
                      onWillAcceptWithDetails: (d) => d.data != index,
                      onAcceptWithDetails: (d) => _swapBottles(d.data, index),
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
                                width: 130,
                              ),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.25,
                            child: Image.asset(
                              playerOrder[index]['asset']!,
                              width: 130,
                            ),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isTarget
                                    ? Colors.yellowAccent
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: isTarget
                                  ? [
                                      BoxShadow(
                                        color: Colors.yellow.withOpacity(0.5),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      )
                                    ]
                                  : [],
                            ),
                            child: Image.asset(
                              playerOrder[index]['asset']!,
                              width: 140,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),

            // Action Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 38),
                child: _ActionButton(
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
            color: isUrgent
                ? Colors.red
                : const Color.fromARGB(218, 219, 183, 38),
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          timerDisplay,
          style: GoogleFonts.boogaloo(
            color: isUrgent
                ? Colors.white
                : const Color.fromARGB(255, 82, 66, 34),
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
              border: Border.all(
                color: const Color.fromARGB(218, 219, 183, 38),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                )
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

// ── Hint Bubble ───────────────────────────────────────────────────────
class _HintBubble extends StatelessWidget {
  final String message;
  const _HintBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(240, 230, 240, 255),
        border: Border.all(color: const Color(0xFFAAC4FF), width: 2),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8)
        ],
      ),
      child: Text(
        message,
        style: GoogleFonts.boogaloo(
          color: const Color(0xFF3A3A5C),
          fontSize: 17,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// ── Action Button ─────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF5D060), Color(0xFFD4A020)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: const Color(0xFFB08010), width: 3),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF7A5C08),
                offset: Offset(0, 4),
                blurRadius: 0,
              ),
              BoxShadow(
                color: Color(0x44000000),
                offset: Offset(0, 6),
                blurRadius: 10,
              ),
            ],
          ),
          child: Text(
            label,
            style: GoogleFonts.boogaloo(
              color: const Color(0xFF4A3000),
              fontSize: 22,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable Game Dialog ──────────────────────────────────────────────
class _GameDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final List<Widget>? actions;
  final bool showClose;
  final Widget? customContent;

  const _GameDialog({
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.actions,
    this.showClose = false,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showClose)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.boogaloo(
                fontSize: 20,
                color: const Color(0xFF3A3A5C),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: subtitleColor ?? const Color(0xFF666666),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (customContent != null) ...[
              const SizedBox(height: 12),
              customContent!,
            ],
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 18),
              Row(
                children: actions!
                    .map((a) => Expanded(child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: a,
                        )))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Dialog Button ─────────────────────────────────────────────────────
class _DialogBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool outlined;
  final bool danger;

  const _DialogBtn({
    required this.label,
    required this.onTap,
    this.outlined = false,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: outlined || danger
              ? null
              : const LinearGradient(
                  colors: [Color(0xFFF5D060), Color(0xFFD4A020)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          color: danger
              ? const Color(0xFFFF6B6B)
              : outlined
                  ? Colors.white
                  : null,
          border: Border.all(
            color: danger
                ? const Color(0xFFE05050)
                : outlined
                    ? const Color(0xFFDDDDDD)
                    : const Color(0xFFB08010),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            if (!outlined)
              BoxShadow(
                color: danger
                    ? const Color(0xFFC04040)
                    : const Color(0xFF7A5C08),
                offset: const Offset(0, 3),
                blurRadius: 0,
              ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.boogaloo(
            fontSize: 15,
            color: danger
                ? Colors.white
                : outlined
                    ? const Color(0xFF555555)
                    : const Color(0xFF4A3000),
          ),
        ),
      ),
    );
  }
}

// ── Settings Row ──────────────────────────────────────────────────────
class _SettingsRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: const Color(0xFFC8860A),
          ),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: const Color(0xFF444444),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}