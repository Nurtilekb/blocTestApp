import 'package:bloctestapp/pages/create/create_note_page.dart'
    show NoteCategory;
import 'package:bloctestapp/models/category_model.dart';
import 'package:bloctestapp/widgets/note_dateail_widgets/detail_tittle_field.dart';
import 'package:bloctestapp/widgets/note_dateail_widgets/tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:bloctestapp/widgets/note_dateail_widgets/detail_content_field.dart';
import 'package:bloctestapp/widgets/note_dateail_widgets/detail_category_badge.dart';
import 'package:bloctestapp/widgets/note_dateail_widgets/detail_edit_buttons.dart';
import 'package:bloctestapp/bloc/notes/notes_bloc.dart';
import 'package:bloctestapp/models/notes_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteDetailPage extends StatefulWidget {
  final String title;
  final String content;
  final String category;
  final Color categoryColor;
  final String idGeter;
  final DateTime dateTime;
  final String categoryId;

  const NoteDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.category,
    required this.categoryColor,
    required this.dateTime,
    required this.idGeter,
    required this.categoryId,
  });

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  bool isEditing = false;
  String _selectedCategory = '';
  String _selectedCategoryId = '';
  List<NoteCategory> _allCategories = [];

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final _categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _selectedCategoryId = widget.categoryId.isNotEmpty
        ? widget.categoryId
        : 'uv-c';
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
    _loadCategories();
  }

  void _loadCategories() {
    context.read<NotesBloc>().add(LoadCategories());
  }

  void _processCategories(List<CategoryModel> savedCategories) {
    final List<NoteCategory> result = [];

    for (final cat in savedCategories) {
      result.add(
        NoteCategory(
          id: cat.id,
          name: cat.name,
          icon: Icons.folder,
          color: const Color(0xFFAF52DE),
        ),
      );
    }

    // Если _selectedCategoryId не совпадает с реальным — находим по имени
    final hasMatch = result.any((c) => c.id == _selectedCategoryId);
    if (!hasMatch && _allCategories.isNotEmpty) {
      final oldCat = _allCategories.firstWhere(
        (c) => c.id == _selectedCategoryId,
        orElse: () => _allCategories.first,
      );
      final realCat = result.firstWhere(
        (c) => c.name == oldCat.name,
        orElse: () => result.isNotEmpty ? result.first : oldCat,
      );
      _selectedCategoryId = realCat.id;
      _selectedCategory = realCat.name;
    }

    setState(() => _allCategories = result);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() => isEditing = !isEditing);
  }

  void _onCategoryChanged(String newCategory) {
    final match = _allCategories.firstWhere(
      (c) => c.name == newCategory,
      orElse: () => _allCategories.isNotEmpty
          ? _allCategories.first
          : NoteCategory(
              id: '',
              name: newCategory,
              icon: Icons.folder,
              color: const Color(0xFFAF52DE),
            ),
    );
    setState(() {
      _selectedCategory = newCategory;
      _selectedCategoryId = match.id;
    });
  }

  Color get _currentCategoryColor {
    final match = _allCategories.firstWhere(
      (c) => c.name == _selectedCategory,
      orElse: () => _allCategories.isNotEmpty
          ? _allCategories.first
          : NoteCategory(
              id: '',
              name: _selectedCategory,
              icon: Icons.folder,
              color: widget.categoryColor,
            ),
    );
    return match.color;
  }

  void _onCategoryAdded(NoteCategory newCategory) {
    context.read<NotesBloc>().add(
      CreateCategory(newCategory.name, id: newCategory.id),
    );
    setState(() {
      _allCategories.add(newCategory);
      _selectedCategory = newCategory.name;
      _selectedCategoryId = newCategory.id;
    });
  }

  void _onCategoryDeleted(String id) {
    final idx = _allCategories.indexWhere((c) => c.id == id);
    if (idx == -1) return;
    final deletedName = _allCategories[idx].name;

    setState(() {
      _allCategories.removeAt(idx);
      if (_allCategories.isEmpty) {
        _selectedCategory = 'Личное';
        _selectedCategoryId = 'uv-c';
      } else if (_selectedCategory == deletedName) {
        _selectedCategory = _allCategories.first.name;
        _selectedCategoryId = _allCategories.first.id;
      }
    });

    context.read<NotesBloc>().add(DeleteCategory(id));
  }

  void _onCategoryUpdated(NoteCategory updated) {
    final oldName = _allCategories
        .firstWhere((c) => c.id == updated.id, orElse: () => updated)
        .name;
    context.read<NotesBloc>().add(
      UpdateCategory(id: updated.id, newName: updated.name),
    );
    if (_selectedCategory == oldName) {
      setState(() {
        _selectedCategory = updated.name;
      });
    }
  }

  void _saveChanges() {
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Поля не могут быть пусты !'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      // String categoryId1;
      // if (_selectedCategoryId != '' && _selectedCategoryId.isNotEmpty) {
      //   categoryId1 = _selectedCategoryId;
      // } else if (_allCategories.isNotEmpty) {
      //   categoryId1 = _allCategories.first.id; // Берем первый элемент
      // } else {
      //   categoryId1 = '1'; // Если нет категорий, пустая строка
      // }
      final updatedNote = Notes(
        id: widget.idGeter,
        title: _titleController.text,
        description: _contentController.text,
        category: _selectedCategory,
        date: DateTime.now(),
        categoryId: _selectedCategoryId,
      );

      context.read<NotesBloc>().add(UpdateNote(updatedNote));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Заметка обновлена'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      setState(() => isEditing = false);
      Navigator.pop(context);
    }
  }

  void _cancelEditing() {
    _titleController.text = widget.title;
    _contentController.text = widget.content;
    _selectedCategory = widget.category;
    _selectedCategoryId = widget.categoryId.isNotEmpty
        ? widget.categoryId
        : 'uv-c';
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesBloc, NotesState>(
      listener: (context, state) {
        if (state is CategoriesLoaded) {
          _processCategories(state.categories);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBarViewWidgets(
                  forIsediting: isEditing,
                  idGeter: widget.idGeter,
                  onToggleEdit: _toggleEdit,
                ),
                const SizedBox(height: 24),
                DetailTitleField(
                  isEditing: isEditing,
                  controller: _titleController,
                  title: widget.title,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Категория',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DetailCategoryBadge(
                      category: _selectedCategory,
                      categoryColor: _currentCategoryColor,
                      idGeter: widget.idGeter,
                      isEditing: isEditing,
                      allCategories: _allCategories,
                      categoryNameController: _categoryNameController,
                      onCategoryChanged: _onCategoryChanged,
                      onCategoryAdded: _onCategoryAdded,
                      onCategoryUpdated: _onCategoryUpdated,
                      onCategoryDeleted: _onCategoryDeleted,
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  height: 1,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                ),
                const SizedBox(height: 10),
                DetailContentField(
                  isEditing: isEditing,
                  controller: _contentController,
                  content: widget.content,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: isEditing
            ? DetailEditButtons(onSave: _saveChanges, onCancel: _cancelEditing)
            : const SizedBox(),
      ),
    );
  }
}
