part of 'word_puzzle_bloc.dart';

abstract class WordPuzzleState {}

class WordPuzzleInitial extends WordPuzzleState {}

class WordPuzzleLoading extends WordPuzzleState {}

class WordPuzzleGenerated extends WordPuzzleState {
  final List<List<String>> puzzle;
  WordPuzzleGenerated(this.puzzle);
}

class WordSearchResult extends WordPuzzleState {
  final List<List<String>> puzzle;
  final Set<String> highlightedCells;
  WordSearchResult(this.puzzle, this.highlightedCells);
}
