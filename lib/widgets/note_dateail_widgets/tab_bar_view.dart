import 'package:bloctestapp/bloc/notes/notes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabBarViewWidgets extends StatefulWidget {
  final bool forIsediting;
  final VoidCallback? onToggleEdit;
  final String idGeter;

  const TabBarViewWidgets({
    super.key,
    required this.forIsediting,
    required this.idGeter,
    this.onToggleEdit,
  });

  @override
  State<TabBarViewWidgets> createState() => _TabBarViewWidgetsState();
}

class _TabBarViewWidgetsState extends State<TabBarViewWidgets> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Кнопка назад
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color.fromARGB(75, 0, 0, 0)),
            ),
            child: const Center(
              child: Icon(Icons.arrow_back_ios_rounded, size: 20),
            ),
          ),
        ),
        const Spacer(),

        // Кнопка редактировать
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: widget.onToggleEdit,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color.fromARGB(75, 0, 0, 0)),
            ),
            child: const Center(child: Icon(Icons.edit_outlined, size: 20)),
          ),
        ),
        const SizedBox(width: 10),

        // Кнопка удалить
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () => _showDeleteDialog(context, widget.idGeter),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color.fromARGB(75, 0, 0, 0)),
            ),
            child: const Center(
              child: Icon(
                Icons.delete_outline_outlined,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, String idd) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Удалить заметку?'),
        content: const Text('Это действие нельзя будет отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              context.read<NotesBloc>().add(DeleteNote(idd));
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
