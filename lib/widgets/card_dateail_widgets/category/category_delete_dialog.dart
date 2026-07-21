import 'package:bloctestapp/pages/create/create_note_page.dart';
import 'package:flutter/material.dart';

void showDeleteCategoryDialog({
  required BuildContext context,
  required NoteCategory category,
  ValueChanged<int>? onCategoryDeleted,
}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Удалить категорию?'),
      content: Text(
        'Вы уверены, что хотите удалить категорию "${category.name}"?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            if (onCategoryDeleted != null) {
              onCategoryDeleted(category.id);
            }

            Navigator.pop(ctx);
            Navigator.pop(context);
          },
          child: const Text('Удалить', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
