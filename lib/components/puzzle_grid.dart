// Widget for the Puzzle Grid
import 'package:flutter/material.dart';

class PuzzleGrid extends StatelessWidget {
  final List<List<String>> puzzle;
  final Set<String>? highlightedCells;

  PuzzleGrid({required this.puzzle, this.highlightedCells});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: puzzle[0].length,
        ),
        itemCount: puzzle.length * puzzle[0].length,
        itemBuilder: (context, index) {
          int row = index ~/ puzzle[0].length;
          int col = index % puzzle[0].length;
          String cellKey = "$row-$col";
          bool isHighlighted = highlightedCells?.contains(cellKey) ?? false;

          return GridTile(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                color: isHighlighted ? Colors.green.withOpacity(0.5) : Colors.white,
              ),
              child: Center(
                child: Text(
                  puzzle[row][col],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isHighlighted ? Colors.black : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
