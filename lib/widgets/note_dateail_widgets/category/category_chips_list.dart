import 'package:bloctestapp/pages/create/create_note_page.dart';
import 'package:flutter/material.dart';

import 'category_edit_dialog.dart';
import 'category_delete_dialog.dart';

class CategoryChipsList extends StatelessWidget {
  final List<NoteCategory> categories;
  final String selectedCategoryId;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<NoteCategory>? onCategoryUpdated;
  final ValueChanged<String>? onCategoryDeleted;

  const CategoryChipsList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.onCategoryUpdated,
    this.onCategoryDeleted,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
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

    return Flexible(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(categories.length, (index) {
            final category = categories[index];
            final isSelected = selectedCategoryId == category.id;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => onCategorySelected(category.id),
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
                      Expanded(
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.white : category.color,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isSelected)
                        InkWell(
                          onTap: () => showEditCategoryDialog(
                            context: context,
                            category: category,
                            onCategoryUpdated: onCategoryUpdated,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: isSelected ? Colors.white : category.color,
                            ),
                          ),
                        ),
                      const SizedBox(width: 4),
                      if (isSelected)
                        InkWell(
                          onTap: () => showDeleteCategoryDialog(
                            context: context,
                            category: category,
                            onCategoryDeleted: onCategoryDeleted,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: isSelected ? Colors.white : category.color,
                            ),
                          ),
                        ),
                      if (!isSelected)
                        const Icon(
                          Icons.check,
                          size: 18,
                          color: Colors.transparent,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
