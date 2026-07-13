import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/models/card_manager.dart';
import 'package:bloctestapp/models/user.dart';
import 'package:bloctestapp/pages/create_note_page.dart';
import 'package:bloctestapp/widgets/cards_in_mainpages.dart';
import 'package:bloctestapp/widgets/category_list_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GotCardPage extends StatefulWidget {
  const GotCardPage({super.key});

  @override
  State<GotCardPage> createState() => _GotCardPageState();
}

class _GotCardPageState extends State<GotCardPage> {
  final _controller = ScrollController();
  final CardManager _cardManager = CardManager();
  final String _searchQuery = '';
  String? _selectedCategory;

  List<Notes> get _filteredCards {
    var cards = _cardManager.getAllCards();

    // Фильтр по поиску
    if (_searchQuery.isNotEmpty) {
      cards = cards
          .where(
            (card) =>
                card.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                card.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    // Фильтр по категории
    if (_selectedCategory != null) {
      cards = cards
          .where((card) => card.category == _selectedCategory)
          .toList();
    }

    // Сортировка по дате (новые сверху)
    cards.sort((a, b) => b.date.compareTo(a.date));

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 15),
                  child: SizedBox(
                    height: 40,
                    child: BlocBuilder<NotesBloc, NotesState>(
                      builder: (context, state) {
                        if (state is! NotesLoaded) {
                          return const SizedBox();
                        }

                        final cards = state.notes;

                        return ListView.separated(
                          controller: _controller,
                          scrollDirection: Axis.horizontal,
                          itemCount: cards.length,
                          itemBuilder: (context, index) {
                            final card = cards[index];

                            return CategoryCard(
                              isSelected: false,
                              nameCategory: card.category,
                            );
                          },
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: ListView.separated(
                        itemCount: _filteredCards.length,

                        itemBuilder: (context, index) {
                          final card = _filteredCards[index];
                          return CardsInPage(
                            mainText: card.title,
                            descripText: card.description,
                            dateTime: _formatDate(card.date),

                            categoryText: card.category,
                            detterId: card.id,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 25,
              right: 20,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateNotePage()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Theme.of(
                      context,
                    ).floatingActionButtonTheme.backgroundColor,
                  ),
                  height: 70,
                  width: 70,
                  child: Center(
                    child: Icon(Icons.add, color: Colors.white, size: 35),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дня(ей) назад';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}
