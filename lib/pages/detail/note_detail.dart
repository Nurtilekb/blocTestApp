import 'package:bloctestapp/pages/create/create_note_page.dart'
    show NoteCategory;
import 'package:bloctestapp/services/card_manager.dart';
import 'package:bloctestapp/widgets/card_dateail_widgets/detail_tittle_field.dart';
import 'package:bloctestapp/widgets/card_dateail_widgets/tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:bloctestapp/widgets/card_dateail_widgets/detail_content_field.dart';
import 'package:bloctestapp/widgets/card_dateail_widgets/detail_category_badge.dart';
import 'package:bloctestapp/widgets/card_dateail_widgets/detail_edit_buttons.dart';
import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/models/note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloctestapp/constants/app_constants.dart';

class NoteDetailPage extends StatefulWidget {
  final String title;
  final String content;
  final String category;
  final Color categoryColor;
  final String idGeter;
  final DateTime dateTime;

  const NoteDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.category,
    required this.categoryColor,
    required this.dateTime,
    required this.idGeter,
  });

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  bool isEditing = false;
  String _selectedCategory = '';
  List<NoteCategory> _allCategories = [];

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final _categoryNameController = TextEditingController();

  List<NoteCategory> get _defaultCategories => defaultCategories
      .asMap()
      .map(
        (index, c) => MapEntry(
          index,
          NoteCategory(
            id: index,
            name: c['name'] as String,
            icon: c['icon'] as IconData,
            color: c['color'] as Color,
          ),
        ),
      )
      .values
      .toList();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
    _loadCategories();
  }

  void _loadCategories() {
    final savedCategories = CardManager().getAllCategories();
    final defaults = Map.fromEntries(
      _defaultCategories.map((c) => MapEntry(c.name, c)),
    );

    final List<NoteCategory> result = [];

    for (final cat in savedCategories) {
      if (defaults.containsKey(cat.name)) {
        result.add(defaults[cat.name]!);
        defaults.remove(cat.name);
      } else {
        result.add(
          NoteCategory(
            id: cat.id,
            name: cat.name,
            icon: Icons.folder,
            color: const Color(0xFFAF52DE),
          ),
        );
      }
    }

    for (final cat in defaults.values) {
      result.add(cat);
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
    setState(() => _selectedCategory = newCategory);
  }

  void _onCategoryAdded(NoteCategory newCategory) {
    CardManager().createCategory(newCategory.name);
    _loadCategories();
    final match = _allCategories.firstWhere(
      (c) => c.name == newCategory.name,
      orElse: () => _allCategories.last,
    );
    setState(() {
      _selectedCategory = match.name;
    });
  }

  void _onCategoryDeleted(int id) {
    final deletedCategory = _allCategories.firstWhere(
      (c) => c.id == id,
      orElse: () => _allCategories.first,
    );
    final deletedName = deletedCategory.name;
    CardManager().deleteCategory(id);
    _loadCategories();
    if (_allCategories.isEmpty) {
      setState(() {
        _selectedCategory = '';
      });
      return;
    }
    if (_selectedCategory == deletedName) {
      setState(() {
        _selectedCategory = _allCategories.first.name;
      });
    }
  }

  void _onCategoryUpdated(NoteCategory updated) {
    final oldName = _allCategories
        .firstWhere((c) => c.id == updated.id, orElse: () => updated)
        .name;
    CardManager().updateCategory(updated.id, updated.name);
    _loadCategories();
    if (_selectedCategory == oldName) {
      setState(() {
        _selectedCategory = updated.name;
      });
    }
  }

  void _saveChanges() {
    final updatedNote = Notes(
      id: widget.idGeter,
      title: _titleController.text,
      description: _contentController.text,
      category: _selectedCategory,
      date: DateTime.now(),
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

  void _cancelEditing() {
    _titleController.text = widget.title;
    _contentController.text = widget.content;
    _selectedCategory = widget.category;
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    categoryColor: widget.categoryColor,
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
    );
  }
}
