import 'package:bloctestapp/pages/create/create_note_page.dart';
import 'package:bloctestapp/widgets/card_dateail_widgets/category_sheet.dart';
import 'package:flutter/material.dart';

class DetailCategoryBadge extends StatelessWidget {
  final String category;
  final Color categoryColor;
  final String idGeter;
  final bool isEditing;
  final List<NoteCategory> allCategories;
  final TextEditingController categoryNameController;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<NoteCategory> onCategoryAdded;
  final ValueChanged<NoteCategory>? onCategoryUpdated;
  final ValueChanged<int>? onCategoryDeleted;

  const DetailCategoryBadge({
    super.key,
    required this.category,
    required this.categoryColor,
    required this.idGeter,
    required this.isEditing,
    required this.allCategories,
    required this.categoryNameController,
    required this.onCategoryChanged,
    required this.onCategoryAdded,
    this.onCategoryUpdated,
    this.onCategoryDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: () {
        if (!isEditing) return;
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => CategorySheetContent(
            categories: allCategories,
            selectedCategoryId: _getCategoryId(),
            categoryNameController: categoryNameController,
            onCategorySelected: (int categoryId) {
              final selectedCategory = allCategories.firstWhere(
                (cat) => cat.id == categoryId,
              );
              onCategoryChanged(selectedCategory.name);
            },
            onCategoryAdded: onCategoryAdded,
            onCategoryUpdated: onCategoryUpdated,
            onCategoryDeleted: onCategoryDeleted,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 3),
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: categoryColor.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_outlined, size: 14, color: categoryColor),
            const SizedBox(width: 6),
            Text(
              category,
              style: TextStyle(
                fontSize: 14,
                color: categoryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: categoryColor),
          ],
        ),
      ),
    );
  }

  int _getCategoryId() {
    final found = allCategories.firstWhere(
      (cat) => cat.name == category,
      orElse: () => allCategories.first,
    );
    return found.id;
  }
}
