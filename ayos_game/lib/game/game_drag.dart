
// DRAG-AND SWAP ITEM BOARD ________________________________

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
      return DragTarget<int>(
        onWillAcceptWithDetails: (d) => d.data != i,
        onAcceptWithDetails: (d) => onSwap(d.data, i),

        builder: (context, candidates, _) {
          final isTarget = candidates.isNotEmpty;

          return Draggable<int>(
            data: i,
            feedback: Material(
              color: Colors.transparent,
              child: Transform.scale(
                scale: 1.08,
                child: Image.asset(
                  items[i].asset,
                  width: width,
                ),
              ),
            ),

            childWhenDragging: Opacity(
              opacity: 0.25,
              child: Image.asset(
                items[i].asset,
                width: width,
              ),
            ),

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),

              decoration: BoxDecoration(
                border: Border.all(
                  color: isTarget? Colors.yellowAccent: Colors.transparent,
                  width: 2.5,
                ),

                borderRadius: BorderRadius.circular(6),

                boxShadow: isTarget? [
                  BoxShadow(
                    color: Colors.yellow.withValues(alpha: 0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ] : [],
              ),

              child: Image.asset(
                items[i].asset,
                width: width,
              ),
            ),
          );
          },
        );
      }),
    );
  }
}
