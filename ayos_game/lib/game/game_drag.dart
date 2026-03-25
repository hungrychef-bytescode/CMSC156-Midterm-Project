import 'package:flutter/material.dart';
import 'package:ayos_game/models/game_item.dart';

class GameBoard extends StatelessWidget {
  final List<GameItem> items;
  final double width;
  final Function(int, int) onSwap;

  const GameBoard({
    super.key,
    required this.items,
    required this.width,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(items.length, (i) {
        return Draggable<int>(
          data: i,
          feedback: Image.asset(items[i].asset, width: width),
          child: DragTarget<int>(
            onAcceptWithDetails: (d) => onSwap(d.data, i),
            builder: (_, _, _) =>
                Image.asset(items[i].asset, width: width),
          ),
        );
      }),
    );
  }
}