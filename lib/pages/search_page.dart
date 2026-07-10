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

  // List<String> get _categories {
  //   final cards = _cardManager.getAllCards();
  //   return cards.map((c) => c.category).toSet().toList();
  // }

  // List<Notes> get _filteredCards {
  //   var cards = _cardManager.getAllCards();

  //   // Фильтр по поиску
  //   if (_searchQuery.isNotEmpty) {
  //     cards = cards
  //         .where(
  //           (card) =>
  //               card.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
  //               card.description.toLowerCase().contains(
  //                 _searchQuery.toLowerCase(),
  //               ),
  //         )
  //         .toList();
  //   }

  //   // Фильтр по категории
  //   if (_selectedCategory != null) {
  //     cards = cards
  //         .where((card) => card.category == _selectedCategory)
  //         .toList();
  //   }

  //   // Сортировка по дате (новые сверху)
  //   cards.sort((a, b) => b.date.compareTo(a.date));

  //   return cards;
  // }

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
                      if (_searchQuery == null || _searchQuery.isEmpty) {
                        return SizedBox(
                          child: Center(child: Text('Поиск заметок...')),
                        );
                      } else
                        return BlocBuilder<NotesBloc, NotesState>(
                          builder: (context, state) {
                            if (state is! NotesLoaded) {
                              return const SizedBox();
                            }

                            final cards = state.notes;

                            return ListView.separated(
                              itemCount: cards.length,
                              itemBuilder: (context, index) {
                                return CardsInPage(
                                  mainText: cards[index].title,
                                  descripText: cards[index].description,
                                  dateTime: ("${cards[index].date}"),
                                  categoryText: cards[index].category,
                                  detterId: cards[index].id,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 12);
                              },
                            );
                          },
                        );
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
