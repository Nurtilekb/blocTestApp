import 'dart:nativewrappers/_internal/vm/lib/async_patch.dart';

import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/models/card_manager.dart';
import 'package:bloctestapp/models/user.dart';
import 'package:bloctestapp/widgets/app_input_widget.dart';
import 'package:bloctestapp/widgets/cards_in_mainpages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  ScrollController scrollor = ScrollController();
  final CardManager _cardManager = CardManager();
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });

                        context.read<NotesBloc>().add(SearchNotes(value));
                      },
                      filledColor: Colors.white,
                      cursorColor: const Color.fromARGB(255, 69, 100, 240),
                      leading: const Icon(Icons.search, color: Colors.blueGrey),
                      controller: _searchController,
                      hintText: 'Поиск заметок...',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
                child: SizedBox(
                  child: BlocBuilder<NotesBloc, NotesState>(
                    builder: (context, state) {
                      if (_searchQuery.isEmpty) {
                        return const Center(child: Text('Поиск заметок...'));
                      }

                      if (state is NotesLoaded) {
                        final notes = state.notes;

                        return ListView.separated(
                          itemCount: notes.length,

                          itemBuilder: (context, index) {
                            final note = notes[index];

                            return CardsInPage(
                              mainText: note.title,
                              descripText: note.description,
                              dateTime: "${note.date}",
                              categoryText: note.category,
                              detterId: note.id,
                            );
                          },

                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
