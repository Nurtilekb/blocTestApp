import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/models/note.dart';
import 'package:bloctestapp/services/card_manager.dart';
import 'package:bloctestapp/widgets/card_dateail_widgets/category_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloctestapp/constants/app_constants.dart';

//  Модель категории
class NoteCategory {
  final int id;
  final String name;
  final IconData icon;
  final Color color;

  const NoteCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();
  final DateTime _selectedDate = DateTime.now();

  int _selectedCategoryId = 0;
  List<NoteCategory> _categories = [];

  List<NoteCategory> get _defaultCategories => defaultCategories
      .asMap()
      .map((index, c) => MapEntry(
            index,
            NoteCategory(
              id: index,
              name: c['name'] as String,
              icon: c['icon'] as IconData,
              color: c['color'] as Color,
            ),
          ))
      .values
      .toList();

  NoteCategory get _currentCategory => _categories.firstWhere(
    (c) => c.id == _selectedCategoryId,
    orElse: () => _categories.first,
  );

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    final savedCategories = CardManager().getAllCategories();
    final defaults = Map.fromEntries(
      _defaultCategories.map((c) => MapEntry(c.name, c)),
    );

    final List<NoteCategory> result = [];
    int nextId = _defaultCategories.length;

    for (final cat in savedCategories) {
      if (defaults.containsKey(cat.name)) {
        result.add(defaults[cat.name]!);
        defaults.remove(cat.name);
      } else {
        result.add(
          NoteCategory(
            id: nextId++,
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

    setState(() => _categories = result);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const SizedBox(height: 20),
                _buildTitleField(),
                const SizedBox(height: 12),
                _buildCategorySelector(),
                const SizedBox(height: 16),
                _buildContentField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveCard() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите заголовок или текст заметки'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_categoryNameController.text.isNotEmpty) {
      // 👇 СОХРАНЯЕМ НОВУЮ КАТЕГОРИЮ В HIVE
      final categoryName = _categoryNameController.text.trim();
      await CardManager().createCategory(categoryName);
      _categoryNameController.clear();
    } else {
      // 👇 ИСПОЛЬЗУЕМ ВЫБРАННУЮ
    }

    final note = Notes(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: content,

      date: _selectedDate,
      category: _currentCategory.name,
    );

    // ignore: use_build_context_synchronously
    context.read<NotesBloc>().add(AddNote(note));

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Карточка создана!'),
        backgroundColor: Colors.green,
      ),
    );

    // ignore: use_build_context_synchronously
    Navigator.pop(context, true);
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        _buildCircleButton(
          icon: Icons.arrow_back_ios_rounded,
          iconColor: Colors.black,
          onTap: () => Navigator.pop(context),
        ),
        const Spacer(),
        _buildCircleButton(
          icon: Icons.delete_outline_outlined,
          iconColor: Colors.red,

          onTap: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(width: 15),
        _buildCircleButton(
          icon: Icons.check,
          iconColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            _saveCard();
          },
        ),
      ],
    );
  }

  // 👇 Переиспользуемая круглая кнопка
  Widget _buildCircleButton({
    required IconData icon,
    required Color iconColor,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(40),
          border: backgroundColor == null
              ? Border.all(color: const Color.fromARGB(75, 0, 0, 0))
              : null,
        ),
        child: Center(child: Icon(icon, size: 20, color: iconColor)),
      ),
    );
  }

  // 👇 Поле заголовка
  Widget _buildTitleField() {
    return TextFormField(
      autofocus: true,
      cursorHeight: 30,
      cursorColor: Theme.of(context).primaryColor,
      controller: _titleController,
      decoration: const InputDecoration(
        hintText: 'Введите заголовок...',
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
      maxLines: 1,
    );
  }

  Widget _buildCategorySelector() {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Row(
        children: [
          const Text('Категория'),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (sheetContext) {
                  return CategorySheetContent(
                    categories: _categories,
                    selectedCategoryId: _selectedCategoryId,
                    categoryNameController: _categoryNameController,
                    onCategorySelected: (id) {
                      setState(() => _selectedCategoryId = id);
                    },
                    onCategoryAdded: (newCategory) async {
                      await CardManager().createCategory(newCategory.name);
                      _loadCategories();
                      final match = _categories.firstWhere(
                        (c) => c.name == newCategory.name,
                        orElse: () => _categories.last,
                      );
                      setState(() {
                        _selectedCategoryId = match.id;
                      });
                    },
                    loadCategories: _categories,
                  );
                },
              );
            },
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(115, 187, 222, 251),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currentCategory.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(
                        255,
                        69,
                        100,
                        240,
                      ), // 👈 Синий текст
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Color.fromARGB(255, 69, 100, 240), // 👈 Синяя иконка
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 👇 Поле контента
  Widget _buildContentField() {
    return Expanded(
      child: TextFormField(
        cursorHeight: 20,
        cursorColor: Theme.of(context).primaryColor,
        controller: _contentController,
        decoration: const InputDecoration(
          hintText: 'Введите заметку...',
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        style: const TextStyle(fontSize: 16, height: 1.5),
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
