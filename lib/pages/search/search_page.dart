import 'dart:async';
import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/models/note.dart';
import 'package:bloctestapp/widgets/app_input_widget.dart';
import 'package:bloctestapp/widgets/note_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  List<Notes> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      if (value.isEmpty) {
        setState(() {
          _searchResults = [];
          _hasSearched = false;
          _isSearching = false;
        });
        return;
      }
      setState(() {
        _isSearching = true;
        _hasSearched = true;
      });
      final repository = context.read<NotesBloc>().repository;
      final results = repository.searchNotes(value);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  void _refreshSearch() {
    if (_searchQuery.isNotEmpty) {
      final repository = context.read<NotesBloc>().repository;
      final results = repository.searchNotes(_searchQuery);
      setState(() {
        _searchResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesBloc, NotesState>(
      listener: (context, state) {
        _refreshSearch();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppInputWidget(
                        autofocus1: true,
                        onChanged: _onSearchChanged,
                        filledColor: Colors.white,
                        cursorColor: const Color.fromARGB(255, 69, 100, 240),
                        leading: const Icon(Icons.search, color: Colors.blueGrey),
                        controller: _searchController,
                        hintText: 'Поиск заметок...',
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Отмена',
                        style: TextStyle(
                          color: Color.fromARGB(255, 69, 100, 240),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildSearchResults(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) {
      return const Center(
        child: Text(
          'Введите запрос для поиска',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasSearched && _searchResults.isEmpty) {
      return const Center(
        child: Text(
          'Ничего не найдено',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    if (_searchResults.isNotEmpty) {
      return ListView.separated(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final note = _searchResults[index];
          return NoteCardWidget(
            mainText: note.title,
            descripText: note.description,
            dateTime: note.date,
            categoryText: note.category,
            detterId: note.id,
          );
        },
        separatorBuilder: (_, _) => const SizedBox(height: 12),
      );
    }

    return const Center(
      child: Text(
        'Введите запрос для поиска',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
