import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter2/ui/word_puzzle_screen.dart';

import 'bloc/word_puzzle_bloc.dart';

void main() {
  runApp(const WordPuzzleApp());
}

class WordPuzzleApp extends StatelessWidget {
  const WordPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => WordPuzzleBloc(
          words: ["APPLE", "MANGO", "ORANGE", "BANANA", "GRAPES"],
          rows: 5,
          cols: 7,
        )..add(GeneratePuzzleEvent()), // Generate puzzle on app start
        child: WordPuzzleScreen(),
      ),
    );
  }
}
