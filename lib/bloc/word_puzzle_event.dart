part of 'word_puzzle_bloc.dart';

abstract class WordPuzzleEvent {}

class GeneratePuzzleEvent extends WordPuzzleEvent {}

class SearchWordEvent extends WordPuzzleEvent {
  final String searchQuery;
  SearchWordEvent(this.searchQuery);
}
