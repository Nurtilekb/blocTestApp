import 'package:bloctestapp/pages/create/create_note_page.dart';
import 'package:bloctestapp/widgets/app_input_widget.dart';
import 'package:flutter/material.dart';

class CategorySheetContent extends StatefulWidget {
  final List<NoteCategory> categories;
  final int selectedCategoryId;
  final TextEditingController categoryNameController;
  final ValueChanged<int> onCategorySelected;
  final ValueChanged<NoteCategory> onCategoryAdded;

  const CategorySheetContent({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.categoryNameController,
    required this.onCategorySelected,
    required this.onCategoryAdded,
    required List<NoteCategory> loadCategories,
  });

  @override
  State<CategorySheetContent> createState() => _CategorySheetContentState();
}

class _CategorySheetContentState extends State<CategorySheetContent> {
  bool _isAddingCategory = false;
  late int _localSelectedId;

  @override
  void initState() {
    super.initState();
    _localSelectedId = widget.selectedCategoryId; // 👈 Начальное значение
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
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
            if (!_isAddingCategory) ...[
              _buildCategoryLabel(),
              const SizedBox(height: 12),
              _buildCategoryChips(),
            ],
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
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
          _isAddingCategory ? 'Новая категория' : 'Категория',
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
          if (!_isAddingCategory) {
            // widget.categoryNameController.clear();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: (_isAddingCategory ? Colors.red : Colors.blue).withValues(
            alpha: 0.1,
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
                  autofocus1: true,
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
    if (widget.categories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'Нет категорий',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        final category = widget.categories[index];
        final isSelected = _localSelectedId == category.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              setState(() {
                _localSelectedId = category.id;
              });
              widget.onCategorySelected(category.id);
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? category.color
                    : category.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
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
                children: [
                  Icon(
                    category.icon,
                    size: 18,
                    color: isSelected ? Colors.white : category.color,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white : category.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    const Icon(Icons.check, size: 18, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      },
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
              color: const Color.fromARGB(255, 116, 85, 202),
            );

            setState(() {
              _isAddingCategory = false;
              widget.onCategoryAdded(newCategory);
              widget.categoryNameController.clear();
            });
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
