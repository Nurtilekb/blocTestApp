import 'dart:async';
import 'package:bloctestapp/bloc/notes_bloc.dart';
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
        context.read<NotesBloc>().add(const SearchNotes(query: ''));
        setState(() => _hasSearched = false);
        return;
      }
      setState(() => _hasSearched = true);

      context.read<NotesBloc>().add(SearchNotes(query: value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Expanded(child: _buildSearchResults()),
            ],
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

    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotesError) {
          return Center(
            child: Text(
              'Ошибка: ${state.message}',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }

        if (state is NotesLoaded) {
          final results = state.notes;

          if (!_hasSearched) {
            return const Center(
              child: Text(
                'Введите запрос для поиска',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          if (results.isEmpty) {
            return const Center(
              child: Text(
                'Ничего не найдено',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final note = results[index];
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
      },
    );
  }
}
