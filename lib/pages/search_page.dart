import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/widgets/app_input_widget.dart';
import 'package:bloctestapp/widgets/cards_in_mainpages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  final NotesBloc notesBloc;

  const SearchPage({super.key, required this.notesBloc});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      widget.notesBloc.add(const GetNotesEvent());
    } else {
      widget.notesBloc.add(SearchNotesEvent(query));
    }
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
                      filledColor: Colors.white,
                      cursorColor: const Color.fromARGB(255, 69, 100, 240),
                      leading: const Icon(Icons.search, color: Colors.blueGrey),
                      controller: _searchController,
                      hintText: 'Поиск заметок...',
                      onChanged: _onSearchChanged,
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
              BlocBuilder<NotesBloc, NotesState>(
                bloc: widget.notesBloc,
                builder: (context, state) {
                  if (state is NotesLoaded) {
                    return Text(
                      '${state.notes.length} ${_getResultText(state.notes.length)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.blueGrey,
                      ),
                    );
                  }
                  return const Text(
                    '0 результатов',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.blueGrey,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<NotesBloc, NotesState>(
                  bloc: widget.notesBloc,
                  builder: (context, state) {
                    if (state is NotesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is NotesLoaded) {
                      if (state.notes.isEmpty) {
                        return const Center(child: Text('Заметки не найдены'));
                      }
                      return ListView.separated(
                        itemCount: state.notes.length,
                        itemBuilder: (context, index) {
                          return CardsInPage(
                            note: state.notes[index],
                            notesBloc: widget.notesBloc,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                      );
                    } else if (state is NotesError) {
                      return Center(child: Text('Ошибка: ${state.message}'));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getResultText(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'результат';
    } else if (count % 10 >= 2 &&
        count % 10 <= 4 &&
        (count % 100 < 10 || count % 100 >= 20)) {
      return 'результата';
    } else {
      return 'результатов';
    }
  }
}
