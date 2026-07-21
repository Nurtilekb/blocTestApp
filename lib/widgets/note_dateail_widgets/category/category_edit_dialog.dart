import 'package:bloctestapp/pages/create/create_note_page.dart';
import 'package:flutter/material.dart';

void showEditCategoryDialog({
  required BuildContext context,
  required NoteCategory category,
  ValueChanged<NoteCategory>? onCategoryUpdated,
}) {
  final controller = TextEditingController(text: category.name);

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Редактировать категорию'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Новое название'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              final updatedCategory = NoteCategory(
                id: category.id,
                name: controller.text,
                icon: category.icon,
                color: category.color,
              );

              if (onCategoryUpdated != null) {
                onCategoryUpdated(updatedCategory);
              }

              Navigator.pop(ctx);
              Navigator.pop(context);
            }
          },
          child: const Text('Сохранить'),
        ),
      ],
    ),
  );
}
