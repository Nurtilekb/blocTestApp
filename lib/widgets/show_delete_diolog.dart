import 'package:bloctestapp/bloc/notes/notes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowDeleteDiolog extends StatefulWidget {
  const ShowDeleteDiolog({super.key, required this.getId});
  final String getId;
  @override
  State<ShowDeleteDiolog> createState() => _ShowDeleteDiologState();
}

class _ShowDeleteDiologState extends State<ShowDeleteDiolog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.fromLTRB(18, 48, 18, 28),
        height: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/delete.png', width: 40),

            // Icon(Icons.delete_outline),
            Text(
              "Удалить заметку?",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight(700)),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.center,
                "Действие нельзя отменить. Заметка будет удалена навсегда",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight(500)),
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  context.read<NotesBloc>().add(DeleteNote(widget.getId));
                  Navigator.pop(context);
                },
                child: Text('Удалить'),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                clipBehavior: Clip.antiAlias,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  elevation: WidgetStatePropertyAll(4),
                  shadowColor: WidgetStatePropertyAll(Colors.black26),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Отмена',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
