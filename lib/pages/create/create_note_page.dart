import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/models/notes_model.dart';
import 'package:bloctestapp/models/category_model.dart';
import 'package:bloctestapp/widgets/card_dateail_widgets/category/category_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Вспомогательная модель для отображения категории в UI
class NoteCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const NoteCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory NoteCategory.fromCategoryModel(CategoryModel model) {
    return NoteCategory(
      id: model.id,
      name: model.name,
      icon: Icons.folder,
      color: const Color(0xFFAF52DE),
    );
  }
}

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();
  final DateTime _selectedDate = DateTime.now();

  String _selectedCategoryId = '';
  List<NoteCategory> _categories = [];
  
  // Флаг загрузки категорий
  bool _isLoadingCategories = true;

  NoteCategory get _currentCategory {
    if (_categories.isEmpty) {
      return const NoteCategory(
        id: '',
        name: 'Личное',
        icon: Icons.person,
        color: Color(0xFF007AFF),
      );
    }
    
    // Если выбранный ID не найден, возвращаем первую категорию
    return _categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => _categories.first,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    context.read<NotesBloc>().add(LoadCategories());
  }

  void _processCategories(List<CategoryModel> savedCategories) {
    final result = savedCategories
        .map((cat) => NoteCategory.fromCategoryModel(cat))
        .toList();

    setState(() {
      _categories = result;
      _isLoadingCategories = false;
      
      // Если текущий ID не совпадает ни с одной категорией, выбираем первую
      if (_selectedCategoryId.isEmpty || 
          !result.any((c) => c.id == _selectedCategoryId)) {
        _selectedCategoryId = result.isNotEmpty ? result.first.id : '';
      }
    });
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
    return BlocListener<NotesBloc, NotesState>(
      listener: (context, state) {
        if (state is NotesLoaded) {
          _processCategories(state.categories);
        } else if (state is NotesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoadingCategories = false);
        }
      },
      child: Scaffold(
        body: SafeArea(
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

  /// Сохранение заметки - теперь без Completer и гонок состояний
  Future<void> _saveCard() async {
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

    String categoryId = _selectedCategoryId;

    // Если введено новое имя категории - создаём её через BLoC
    if (_categoryNameController.text.isNotEmpty) {
      final categoryName = _categoryNameController.text.trim();
      
      // Отправляем событие на создание категории
      context.read<NotesBloc>().add(CreateCategory(categoryName));
      _categoryNameController.clear();

      // Ждём обновления состояния BLoC
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        final state = context.read<NotesBloc>().state;
        if (state is NotesLoaded) {
          final newCat = state.categories.firstWhere(
            (c) => c.name == categoryName,
            orElse: () => CategoryModel(id: '', name: ''),
          );
          if (newCat.id.isNotEmpty) {
            categoryId = newCat.id;
            return false;
          }
        }
        return false; // Таймаут 1 сек
      }).timeout(
        const Duration(seconds: 2),
        onTimeout: () {},
      );
    }

    final currentCat = _currentCategory;
    final note = Notes(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: content,
      date: _selectedDate,
      category: currentCat.name,
      categoryId: categoryId,
    );

    if (!mounted) return;
    context.read<NotesBloc>().add(AddNote(note));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Заметка создана!'),
        backgroundColor: Colors.green,
      ),
    );

    if (!mounted) return;
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
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(width: 15),
        _buildCircleButton(
          icon: Icons.check,
          iconColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          onTap: _saveCard,
        ),
      ],
    );
  }

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
            onTap: _showCategorySheet,
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
                  if (_isLoadingCategories)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Text(
                      _currentCategory.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 69, 100, 240),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Color.fromARGB(255, 69, 100, 240),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (
            BuildContext context,
            ScrollController scrollController,
          ) {
            return CategorySheetContent(
              categories: _categories,
              selectedCategoryId: _selectedCategoryId,
              categoryNameController: _categoryNameController,
              onCategorySelected: (id) {
                setState(() => _selectedCategoryId = id);
              },
              onCategoryAdded: (newCategory) {
                context.read<NotesBloc>().add(
                  CreateCategory(newCategory.name),
                );
              },
              onCategoryUpdated: (updatedCategory) {
                context.read<NotesBloc>().add(
                  UpdateCategory(
                    id: updatedCategory.id,
                    newName: updatedCategory.name,
                  ),
                );
              },
              onCategoryDeleted: (categoryId) {
                context.read<NotesBloc>().add(
                  DeleteCategory(categoryId),
                );
                if (_selectedCategoryId == categoryId && _categories.isNotEmpty) {
                  setState(() {
                    _selectedCategoryId = _categories.first.id;
                  });
                }
              },
            );
          },
        );
      },
    );
  }

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
