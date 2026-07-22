import 'package:bloctestapp/pages/create/create_note_page.dart';
import 'package:bloctestapp/widgets/app_input_widget.dart';
import 'package:flutter/material.dart';

import 'category_chips_list.dart';

class CategorySheetContent extends StatefulWidget {
  final List<NoteCategory> categories;
  final String selectedCategoryId;
  final TextEditingController categoryNameController;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<NoteCategory> onCategoryAdded;
  final ValueChanged<NoteCategory>? onCategoryUpdated;
  final ValueChanged<String>? onCategoryDeleted;

  const CategorySheetContent({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.categoryNameController,
    required this.onCategorySelected,
    required this.onCategoryAdded,
    this.onCategoryUpdated,
    this.onCategoryDeleted,
  });

  @override
  State<CategorySheetContent> createState() => _CategorySheetContentState();
}

class _CategorySheetContentState extends State<CategorySheetContent> {
  bool _isAddingCategory = false;
  late String _localSelectedId;

  @override
  void initState() {
    super.initState();
    _localSelectedId = widget.selectedCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
            const SizedBox(height: 10),
            _buildAddCategoryField(),
            if (!_isAddingCategory) ...[
              _buildCategoryLabel(),
              const SizedBox(height: 12),
              CategoryChipsList(
                categories: widget.categories,
                selectedCategoryId: _localSelectedId,
                onCategorySelected: (id) {
                  setState(() => _localSelectedId = id);
                  widget.onCategorySelected(id);
                },
                onCategoryUpdated: widget.onCategoryUpdated,
                onCategoryDeleted: widget.onCategoryDeleted,
              ),
            ],
            const SizedBox(height: 12),
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
            widget.categoryNameController.clear();
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
          ? AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: 1.0,
              child: AppInputWidget(
                controller: widget.categoryNameController,
                hintText: 'Название категории...',
                autofocus1: true,
              ),
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

  /////////////////////////////
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_isAddingCategory &&
              widget.categoryNameController.text.isNotEmpty) {
            final newCategory = NoteCategory(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: widget.categoryNameController.text,
              icon: Icons.folder,
              color: const Color.fromARGB(255, 85, 130, 202),
            );

            widget.onCategoryAdded(newCategory);
            widget.categoryNameController.clear();
            setState(() {
              _isAddingCategory = false;
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
