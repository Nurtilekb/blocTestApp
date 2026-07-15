import 'package:bloctestapp/constants/app_constants.dart'; // Убедитесь, что импорт есть
import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/pages/create/create_note_page.dart';
import 'package:bloctestapp/widgets/note_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithNotes extends StatefulWidget {
  const WithNotes({super.key});

  @override
  State<WithNotes> createState() => _WithNotesState();
}

class _WithNotesState extends State<WithNotes> {
  // По умолчанию выбрано "Все"
  String _selectedCategory = 'Все';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryList(),
                const SizedBox(height: 16),
                Expanded(child: _buildNoteList()),
              ],
            ),
            _buildFloatingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 15),
      child: SizedBox(
        height: 40,
        child: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (state is! NotesLoaded) return const SizedBox();

            // 1. Получаем уникальные категории пользователя
            final userCategories = state.notes
                .map((note) => note.category)
                .toSet();

            // 2. Формируем итоговый список вручную, чтобы контролировать порядок
            final List<String> allCategories = [];

            // Добавляем "Все" первым элементом
            allCategories.add('Все');

            // Добавляем стандартные категории из констант (если их нет у пользователя, они всё равно будут в меню)
            for (var cat in defaultCategories) {
              if (!allCategories.contains(cat['name'])) {
                allCategories.add(cat['name'] as String);
              }
            }

            // Добавляем пользовательские категории, которых нет в стандарте
            for (var cat in userCategories) {
              if (!allCategories.contains(cat)) {
                allCategories.add(cat);
              }
            }

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allCategories.length,
              itemBuilder: (context, index) {
                final category = allCategories[index];
                final isSelected = _selectedCategory == category;

                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.3,
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey[300]!,
                      ),
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 2),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(width: 12),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoteList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoaded) {
            var notes = state.notes;

            // Фильтрация: если выбрано не "Все", фильтруем по категории
            if (_selectedCategory != 'Все') {
              notes = notes
                  .where((note) => note.category == _selectedCategory)
                  .toList();
            }

            // Сортировка по дате
            notes.sort((a, b) => b.date.compareTo(a.date));

            if (notes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      _selectedCategory == 'Все'
                          ? 'Нет заметок'
                          : 'Нет заметок с категорией "$_selectedCategory"',
                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteCardWidget(
                  mainText: note.title,
                  descripText: note.description,
                  dateTime: _formatDate(note.date),
                  categoryText: note.category,
                  detterId: note.id,
                );
              },
              separatorBuilder: (_, _) => const SizedBox(height: 12),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildFloatingButton() {
    return Positioned(
      bottom: 25,
      right: 20,
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateNotePage()),
          );
          if (result == true && context.mounted) {
            context.read<NotesBloc>().add(LoadNotes());
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: Color(0xFF007AFF),
          ),
          height: 70,
          width: 70,
          child: const Center(
            child: Icon(Icons.add, color: Colors.white, size: 35),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const monthNames = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];

    // Всегда возвращаем формат "5 июня"
    return '${date.day} ${monthNames[date.month - 1]}';
  }

  // Вспомогательный метод для формата "5 июня"
  String _getFormattedDateOnly(DateTime date) {
    const monthNames = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];
    return '${date.day} ${monthNames[date.month - 1]}';
  }

  // Вспомогательный метод для склонения дней (если оставили логику "назад")
  String _getDayWord(int number) {
    final n = number % 100;
    if (n >= 11 && n <= 19) return 'дней';
    final m = n % 10;
    if (m == 1) return 'день';
    if (m >= 2 && m <= 4) return 'дня';
    return 'дней';
  }
}
