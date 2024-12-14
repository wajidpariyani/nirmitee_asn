import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';

part 'word_puzzle_event.dart';
part 'word_puzzle_state.dart';

class WordPuzzleBloc extends Bloc<WordPuzzleEvent, WordPuzzleState> {
  final List<String> words;
  final int rows;
  final int cols;

  WordPuzzleBloc({required this.words, required this.rows, required this.cols})
      : super(WordPuzzleInitial()) {
    on<GeneratePuzzleEvent>(_onGeneratePuzzle);
    on<SearchWordEvent>(_onSearchWord);
  }

  Future<void> _onGeneratePuzzle(
      GeneratePuzzleEvent event, Emitter<WordPuzzleState> emit) async {
    emit(WordPuzzleLoading()); // Emit a loading state before generating the puzzle
    final puzzle = await _generatePuzzleAsync(rows, cols, words); // Use async puzzle generation
    emit(WordPuzzleGenerated(puzzle));
  }

  Future<void> _onSearchWord(
      SearchWordEvent event, Emitter<WordPuzzleState> emit) async {
    final currentState = state;

    if (currentState is WordPuzzleGenerated) {
      final highlightedCells =
      await _highlightWordAsync(currentState.puzzle, event.searchQuery.trim());
      emit(WordSearchResult(currentState.puzzle, highlightedCells));
    } else if (currentState is WordSearchResult) {
      // If we are in a WordSearchResult state, update highlighted cells
      final highlightedCells =
      await _highlightWordAsync(currentState.puzzle, event.searchQuery.trim());
      emit(WordSearchResult(currentState.puzzle, highlightedCells));
    }
  }

  Future<List<List<String>>> _generatePuzzleAsync(int rows, int cols, List<String> words) async {
    return await Future(() {
      List<List<String>> grid = List.generate(rows, (i) => List.filled(cols, '', growable: false));
      Random random = Random();
      const String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

      for (var word in words) {
        bool placed = false;

        while (!placed) {
          int startRow = random.nextInt(rows);
          int startCol = random.nextInt(cols);

          List<int> directions = [-1, 0, 1];
          int dRow = directions[random.nextInt(3)];
          int dCol = directions[random.nextInt(3)];

          if (dRow == 0 && dCol == 0) continue;

          if (_canPlaceWord(grid, word, startRow, startCol, dRow, dCol)) {
            _placeWord(grid, word, startRow, startCol, dRow, dCol);
            placed = true;
          }
        }
      }

      _fillBlanksWithRandomLetters(grid, alphabet, random);
      return grid;
    });
  }


  bool _canPlaceWord(
      List<List<String>> grid, String word, int startRow, int startCol, int dRow, int dCol) {
    for (int i = 0; i < word.length; i++) {
      int newRow = startRow + i * dRow;
      int newCol = startCol + i * dCol;

      if (newRow < 0 ||
          newRow >= grid.length ||
          newCol < 0 ||
          newCol >= grid[0].length) return false;

      if (grid[newRow][newCol] != '' && grid[newRow][newCol] != word[i]) {
        return false;
      }
    }
    return true;
  }

  void _placeWord(
      List<List<String>> grid, String word, int startRow, int startCol, int dRow, int dCol) {
    for (int i = 0; i < word.length; i++) {
      int newRow = startRow + i * dRow;
      int newCol = startCol + i * dCol;
      grid[newRow][newCol] = word[i];
    }
  }

  void _fillBlanksWithRandomLetters(
      List<List<String>> grid, String alphabet, Random random) {
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] == '') {
          grid[i][j] = alphabet[random.nextInt(alphabet.length)];
        }
      }
    }
  }

  Future<Set<String>> _highlightWordAsync(
      List<List<String>> puzzle, String word) async {
    return await Future(() {
      Set<String> highlightedCells = {};

      // Check if the word exists in the list before proceeding
      if (!words.contains(word)) {
        return highlightedCells; // Return empty set if the word is not in the list
      }

      for (int r = 0; r < puzzle.length; r++) {
        for (int c = 0; c < puzzle[0].length; c++) {
          // Clear highlightedCells for each new attempt
          highlightedCells.clear();

          // Search for the word starting from the current cell
          if (_searchWordFromCell(puzzle, r, c, word)) {
            // If found, highlight the corresponding cells
            highlightedCells.addAll(_getHighlightedCells(puzzle, r, c, word));
            return highlightedCells; // Return as soon as the word is found
          }
        }
      }

      // If no match is found, return an empty set
      highlightedCells.clear();
      return highlightedCells;
    });
  }

  bool _searchWordFromCell(
      List<List<String>> puzzle, int startRow, int startCol, String word) {
    List<List<int>> directions = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1],
      [-1, -1],
      [1, 1],
      [-1, 1],
      [1, -1]
    ];

    for (var direction in directions) {
      int dRow = direction[0];
      int dCol = direction[1];

      int r = startRow;
      int c = startCol;
      int wordIndex = 0;

      while (wordIndex < word.length &&
          r >= 0 &&
          r < puzzle.length &&
          c >= 0 &&
          c < puzzle[0].length &&
          puzzle[r][c] == word[wordIndex]) {
        r += dRow;
        c += dCol;
        wordIndex++;
      }

      if (wordIndex == word.length) {
        return true;
      }
    }
    return false;
  }

  Set<String> _getHighlightedCells(
      List<List<String>> puzzle, int startRow, int startCol, String word) {
    Set<String> highlightedCells = {};
    List<List<int>> directions = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1],
      [-1, -1],
      [1, 1],
      [-1, 1],
      [1, -1]
    ];

    for (var direction in directions) {
      int dRow = direction[0];
      int dCol = direction[1];

      int r = startRow;
      int c = startCol;
      int wordIndex = 0;

      while (wordIndex < word.length &&
          r >= 0 &&
          r < puzzle.length &&
          c >= 0 &&
          c < puzzle[0].length &&
          puzzle[r][c] == word[wordIndex]) {
        highlightedCells.add("$r-$c");
        r += dRow;
        c += dCol;
        wordIndex++;
      }

      if (wordIndex == word.length) {
        return highlightedCells;
      }
    }
    return highlightedCells;
  }
}
