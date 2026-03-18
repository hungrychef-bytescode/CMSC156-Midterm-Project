import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:ui';

class DifficultScreen extends StatefulWidget {
  const DifficultScreen({super.key});

  @override
  State<DifficultScreen> createState() => _DifficultScreenState();
}

class _DifficultScreenState extends State<DifficultScreen>
    with TickerProviderStateMixin {
  // ── Config ────────────────────────────────────────────────────────
  int totalTime = 60;
  int itemCount = 3;
  int reward = 5;
  String level = "Difficult";

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
    {"id": "green",  "asset": "assets/images/cheesering.png"},
    {"id": "yellow", "asset": "assets/images/cheezit.png"},
    {"id": "red",    "asset": "assets/images/chizcurls.png"},
    {"id": "red",    "asset": "assets/images/dingdong.png"},
    {"id": "red",    "asset": "assets/images/dingdong.png"},
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
        title: "You guessed all items correctly!",
        showClose: false,
        onClose: _goHome,
        actions: [
          _PillBtn(label: "Back to Menu", onTap: _goHome),
        ],
      ),
    );
  }

  void _showLoseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _GameDialog(
        title: "Time's Up!",
        subtitle: "Better luck next time.",
        showClose: false,
        onClose: _goHome,
        actions: [
          _PillBtn(label: "Back to Menu", onTap: _goHome),
          _PillBtn(label: "Try Again",    onTap: _restart),
        ],
      ),
    );
  }

  void _showExitDialog() {
    if (gameOver) { _goHome(); return; }
    showDialog(
      context: context,
      builder: (ctx) => _GameDialog(
        title: "Are you sure you want to exit the game?",
        subtitle: "Current progress will not be saved",
        showClose: false,
        onClose: () => Navigator.of(ctx).pop(),
        actions: [
          _PillBtn(label: "Continue Playing", onTap: () => Navigator.of(ctx).pop()),
          _PillBtn(label: "Exit Game",         onTap: _goHome),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    bool bgMusic = true;
    bool sfx     = true;
    // Show as a positioned popup anchored to top-right (near the ⋮ button)
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Stack(
          children: [
            // Dismiss on tap outside
            GestureDetector(
              onTap: () => Navigator.of(ctx).pop(),
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
            Positioned(
              top: 64,   // just below the AppBar
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: _SettingsPopup(
                  bgMusic: bgMusic,
                  sfx: sfx,
                  onBgMusicChanged: (v) => setS(() => bgMusic = v),
                  onSfxChanged:     (v) => setS(() => sfx = v),
                  onClose: () => Navigator.of(ctx).pop(),
                ),
              ),
            ),
          ],
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
                      "assets/images/snack_myst.png",
                      width: 80,
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
                                width: 80,
                              ),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.25,
                            child: Image.asset(
                              playerOrder[index]['asset']!,
                              width: 80,
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
                              width: 80,
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

// ── Color Palette (from mockup) ───────────────────────────────────────
// Modal bg:      #C8C6E8  (lavender/periwinkle)
// Modal border:  #9B97D4
// Title text:    #2E2B5F  (deep indigo)
// Subtitle text: #555370
// Pill btn bg:   #F5C842  (gold yellow)
// Pill btn border: #C89A10
// Pill btn text: #4A3000
// AppBar/footer: #382507

// ── Hint Bubble ───────────────────────────────────────────────────────
class _HintBubble extends StatelessWidget {
  final String message;
  const _HintBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEBFF),
        border: Border.all(color: const Color(0xFF9B97D4), width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Text(
        message,
        style: GoogleFonts.boogaloo(
          color: const Color(0xFF2E2B5F),
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
  const _ActionButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

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
            border: Border.all(color: const Color(0xFFC89A10), width: 2.5),
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

// ── Game Dialog (lavender card) ───────────────────────────────────────
class _GameDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showClose;
  final VoidCallback? onClose;

  const _GameDialog({
    required this.title,
    this.subtitle,
    this.actions,
    this.showClose = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF9B97D4), width: 2),
      ),
      backgroundColor: const Color(0xFFC8C6E8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Close button row
            if (showClose)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: onClose ?? () => Navigator.of(context).pop(),
                  child: Container(
                    width: 22, height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9B97D4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              )
            else
              const SizedBox(height: 4),

            const SizedBox(height: 6),

            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2E2B5F),
                height: 1.3,
              ),
            ),

            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF555370),
                ),
              ),
            ],

            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: actions!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Pill Button (gold, used inside dialogs) ───────────────────────────
class _PillBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PillBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF7D45A), Color(0xFFD4A020)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: const Color(0xFFC89A10), width: 1.8),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF7A5C08),
              offset: Offset(0, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF4A3000),
          ),
        ),
      ),
    );
  }
}

// ── Settings Popup (top-right anchored card) ──────────────────────────
class _SettingsPopup extends StatelessWidget {
  final bool bgMusic;
  final bool sfx;
  final ValueChanged<bool> onBgMusicChanged;
  final ValueChanged<bool> onSfxChanged;
  final VoidCallback onClose;

  const _SettingsPopup({
    required this.bgMusic,
    required this.sfx,
    required this.onBgMusicChanged,
    required this.onSfxChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF9B97D4), width: 1.5),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Settings",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2E2B5F),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close, size: 18, color: Color(0xFF888888)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Background Music
          _SettingsCheckRow(
            label: "Background Music",
            value: bgMusic,
            onChanged: onBgMusicChanged,
          ),
          const SizedBox(height: 4),

          // Sound Effects
          _SettingsCheckRow(
            label: "Sound Effects",
            value: sfx,
            onChanged: onSfxChanged,
          ),
          const SizedBox(height: 14),

          // OK button centered
          Center(
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 7),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF7D45A), Color(0xFFD4A020)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(color: const Color(0xFFC89A10), width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF7A5C08),
                      offset: Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  "OK",
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF4A3000),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Settings Checkbox Row ─────────────────────────────────────────────
class _SettingsCheckRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsCheckRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24, height: 24,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: const Color(0xFF6C63C4),
            side: const BorderSide(color: Color(0xFF9B97D4), width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF444444),
          ),
        ),
      ],
    );
  }
}