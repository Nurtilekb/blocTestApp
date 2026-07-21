import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/bloc/repositories/notes_repository.dart';
import 'package:bloctestapp/models/category_model.dart';
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
  String _selectedCategory = 'Все';
  List<CategoryModel> _firestoreCategories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    final repo = context.read<NotesRepository>();
    final categories = await repo.getCategories();
    if (mounted) {
      setState(() => _firestoreCategories = categories);
    }
  }

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

            final userCategories = state.notes
                .map((note) => note.category)
                .toSet();

            final List<String> allCategories = [];

            allCategories.add('Все');

            for (var cat in _firestoreCategories) {
              if (!allCategories.contains(cat.name)) {
                allCategories.add(cat.name);
              }
            }

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
            if (_selectedCategory != 'Все') {
              notes = notes
                  .where((note) => note.category == _selectedCategory)
                  .toList();
            }
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
                  dateTime: note.date,
                  categoryText: note.category,
                  detterId: note.id,
                  categoryId: note.categoryId,
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

          if (result == true && mounted) {
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
}
