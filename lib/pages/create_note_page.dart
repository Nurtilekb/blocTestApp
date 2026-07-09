import 'package:bloctestapp/widgets/app_input_widget.dart';
import 'package:flutter/material.dart';

// 👇 Модель категории
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();

  int _selectedCategoryId = 0;

  // 👇 Типизированный список
  final List<NoteCategory> _categories = [
    NoteCategory(
      id: 0,
      name: 'Личное',
      icon: Icons.person,
      color: Color(0xFF007AFF),
    ),
    NoteCategory(
      id: 1,
      name: 'Работа',
      icon: Icons.work,
      color: Color(0xFF34C759),
    ),
    NoteCategory(
      id: 2,
      name: 'Идеи',
      icon: Icons.lightbulb,
      color: Color(0xFFFF9500),
    ),
    NoteCategory(
      id: 3,
      name: 'Важное',
      icon: Icons.star,
      color: Color(0xFFFF3B30),
    ),
  ];

  // 👇 Getter для текущей категории
  NoteCategory get _currentCategory => _categories.firstWhere(
    (c) => c.id == _selectedCategoryId,
    orElse: () => _categories.first,
  );

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
    );
  }

  // 👇 Верхняя панель
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
          onTap: () {},
        ),
        const SizedBox(width: 15),
        _buildCircleButton(
          icon: Icons.check,
          iconColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {},
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
        child: Center(child: Icon(icon, size: 15, color: iconColor)),
      ),
    );
  }

  // 👇 Поле заголовка
  Widget _buildTitleField() {
    return TextField(
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

  // 👇 Селектор категории
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
                  Text(
                    _currentCategory.name, // 👈 чисто
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

  // 👇 Поле контента
  Widget _buildContentField() {
    return Expanded(
      child: TextField(
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

  // 👇 Bottom Sheet выбора категории
  void _showCategorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _CategorySheetContent(
          categories: _categories,
          selectedCategoryId: _selectedCategoryId,
          categoryNameController: _categoryNameController,
          onCategorySelected: (id) {
            setState(() => _selectedCategoryId = id);
          },
          onCategoryAdded: (newCategory) {
            setState(() {
              _categories.add(newCategory);
              _selectedCategoryId = newCategory.id;
            });
          },
        );
      },
    );
  }
}

// 👇 Отдельный виджет для содержимого Bottom Sheet (чистота!)
class _CategorySheetContent extends StatefulWidget {
  final List<NoteCategory> categories;
  final int selectedCategoryId;
  final TextEditingController categoryNameController;
  final ValueChanged<int> onCategorySelected;
  final ValueChanged<NoteCategory> onCategoryAdded;

  const _CategorySheetContent({
    required this.categories,
    required this.selectedCategoryId,
    required this.categoryNameController,
    required this.onCategorySelected,
    required this.onCategoryAdded,
  });

  @override
  State<_CategorySheetContent> createState() => _CategorySheetContentState();
}

class _CategorySheetContentState extends State<_CategorySheetContent> {
  bool _isAddingCategory = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandle(),
          const SizedBox(height: 20),
          _buildHeader(),
          const SizedBox(height: 12),
          _buildAddCategoryField(),
          _buildCategoryLabel(),
          const SizedBox(height: 12),
          _buildCategoryChips(),
          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Категория',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAddingCategory = !_isAddingCategory;
          if (!_isAddingCategory) widget.categoryNameController.clear();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: (_isAddingCategory ? Colors.red : Colors.blue).withOpacity(
            0.1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              _isAddingCategory ? Icons.close : Icons.add,
              size: 16,
              color: _isAddingCategory ? Colors.red : Colors.blue,
            ),
            const SizedBox(width: 4),
            Text(
              _isAddingCategory ? 'Отмена' : 'Добавить',
              style: TextStyle(
                fontSize: 14,
                color: _isAddingCategory ? Colors.red : Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCategoryField() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _isAddingCategory
          ? Column(
              children: [
                AppInputWidget(
                  controller: widget.categoryNameController,
                  hintText: 'Название категории...',
                ),
                const SizedBox(height: 16),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildCategoryLabel() {
    return Text(
      'Выберите категорию',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.categories.map((category) {
        final isSelected = widget.selectedCategoryId == category.id;
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                category.icon,
                size: 16,
                color: isSelected ? Colors.white : category.color,
              ),
              const SizedBox(width: 4),
              Text(category.name),
            ],
          ),
          selected: isSelected,
          selectedColor: category.color,
          onSelected: (_) => widget.onCategorySelected(category.id),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_isAddingCategory &&
              widget.categoryNameController.text.isNotEmpty) {
            final newCategory = NoteCategory(
              id: widget.categories.length,
              name: widget.categoryNameController.text,
              icon: Icons.folder,
              color: Colors.teal,
            );
            widget.onCategoryAdded(newCategory);
            widget.categoryNameController.clear();
          }
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Сохранить',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
