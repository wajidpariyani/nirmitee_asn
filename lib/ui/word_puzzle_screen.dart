import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:test_flutter2/constants/app_strings.dart';
import 'package:test_flutter2/constants/asset_paths.dart';
import '../bloc/word_puzzle_bloc.dart';
import '../components/puzzle_grid.dart';
import '../components/puzzle_search.dart';

class WordPuzzleScreen extends StatefulWidget {
  @override
  _WordPuzzleScreenState createState() => _WordPuzzleScreenState();
}

class _WordPuzzleScreenState extends State<WordPuzzleScreen> {
  String searchQuery = "";
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String assetPath) async {
    if(searchQuery.isNotEmpty){
      try {
        await _audioPlayer.play(AssetSource(assetPath)); // Play the audio file
      } catch (e) {
        print("$audioErrorTitle$e"); // Log error if audio fails to play
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: BlocConsumer<WordPuzzleBloc, WordPuzzleState>(
        listener: (context, state) async {
          if (state is WordSearchResult) {
            if (state.highlightedCells.isNotEmpty) {
              await _playAudio(correctAudio); // Play correct audio
            } else {
              await _playAudio(incorrectAudio); // Play incorrect audio
            }
          }
        },
        builder: (context, state) {
          if (state is WordPuzzleLoading) {
            // Show a loading spinner during puzzle generation
            return const Center(child: CircularProgressIndicator());
          } else if (state is WordPuzzleGenerated) {
            return Column(
              children: [
                PuzzleSearch(
                  searchQuery: searchQuery,
                  onSearchChanged: (value) {
                    setState(() {
                      searchQuery = value.toUpperCase();
                    });
                    context.read<WordPuzzleBloc>().add(SearchWordEvent(searchQuery));
                  },
                ),
                if (searchQuery.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$searchResultTitle $searchQuery',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                PuzzleGrid(puzzle: state.puzzle),
              ],
            );
          } else if (state is WordSearchResult) {
            return Column(
              children: [
                PuzzleSearch(
                  searchQuery: searchQuery,
                  onSearchChanged: (value) {
                    setState(() {
                      searchQuery = value.toUpperCase();
                    });
                    context.read<WordPuzzleBloc>().add(SearchWordEvent(searchQuery));
                  },
                ),
                if (searchQuery.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$searchResultTitle $searchQuery',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                PuzzleGrid(puzzle: state.puzzle, highlightedCells: state.highlightedCells),
              ],
            );
          }

          // Default state (fallback or initial state)
          return const Center(child: Text(welcomeFallbackText));
        },
      ),
    );
  }
}
