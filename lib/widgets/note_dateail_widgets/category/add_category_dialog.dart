import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloctestapp/bloc/notes_bloc.dart';

class AddCategoryDialog extends StatefulWidget {
  final String idGeter;
  final ValueChanged<String> onCategoryAdded;

  const AddCategoryDialog({
    super.key,
    required this.idGeter,
    required this.onCategoryAdded,
  });

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final newCategory = _controller.text.trim();
    if (newCategory.isEmpty) return;

    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    context.read<NotesBloc>().add(
      CreateCategory(newCategory, id: tempId),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Категория "$newCategory" добавлена'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );

    widget.onCategoryAdded(newCategory);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Новое название:',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Название категории...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _controller.clear();
            Navigator.pop(context);
          },
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
