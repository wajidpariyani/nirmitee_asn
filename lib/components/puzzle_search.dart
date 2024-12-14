import 'dart:async';

import 'package:flutter/material.dart';

class PuzzleSearch extends StatefulWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  PuzzleSearch({
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  _PuzzleSearchState createState() => _PuzzleSearchState();
}

class _PuzzleSearchState extends State<PuzzleSearch> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearchChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search Word',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.search),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}
