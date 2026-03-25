import 'package:ayos_game/models/game_item.dart';
import 'package:flutter/material.dart';

class GameController extends ChangeNotifier {
  late List<GameItem> correctOrder;
  late List<GameItem> playerOrder;

  bool gameStarted = false;
  bool hasGuessed = false;
  bool gameOver = false;


  void setup(List<GameItem> allItems, int itemCount) {
    final shuffled = List<GameItem>.from(allItems)..shuffle();

    correctOrder = shuffled.take(itemCount).toList();
    playerOrder = List<GameItem>.from(correctOrder)..shuffle();

    while (_isCorrect() && playerOrder.length > 1) {
      playerOrder.shuffle();
    }

    notifyListeners();
  }

  void swap(int from, int to) {
    if (from == to || gameOver || !gameStarted) return;

    final tmp = playerOrder[from];
    playerOrder[from] = playerOrder[to];
    playerOrder[to] = tmp;

    hasGuessed = false;
    notifyListeners();
  }

  bool _isCorrect() {
    for (int i = 0; i < correctOrder.length; i++) {
      if (playerOrder[i].id != correctOrder[i].id) return false;
    }
    return true;
  }

  int countCorrectPositions() {
    int hits = 0;
    for (int i = 0; i < correctOrder.length; i++) {
      if (playerOrder[i].id == correctOrder[i].id) hits++;
    }
    return hits;
  }

  bool checkWin() {
    final win = _isCorrect();
    if (win) gameOver = true;
    return win;
  }

  void startGame() {
    gameStarted = true;
    notifyListeners();
  }

  void endGame() {
    gameStarted = false;
    gameOver = true;
    notifyListeners();
  }

  bool guess() {
    if (!gameStarted || gameOver) return false;
  
    hasGuessed = !hasGuessed;
  
    if (_isCorrect()) {
      gameOver = true;
      notifyListeners();
      return true;
    }
  
    notifyListeners();
    return false;
  }
  
  void reset(List<GameItem> allItems, int itemCount) {
    hasGuessed = false;
    gameOver = false;
    setup(allItems, itemCount);
  }
  
}