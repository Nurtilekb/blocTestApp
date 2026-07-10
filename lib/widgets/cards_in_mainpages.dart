import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/pages/card_detail.dart';
import 'package:bloctestapp/widgets/show_delete_diolog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardsInPage extends StatefulWidget {
  const CardsInPage({
    super.key,
    required this.mainText,
    required this.descripText,
    required this.dateTime,
    required this.categoryText,
    required this.detterId,
  });
  final String mainText;
  final String descripText;
  final String dateTime;
  final String categoryText;
  final String detterId;
  @override
  State<CardsInPage> createState() => _CardsInPageState();
}

class _CardsInPageState extends State<CardsInPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailPage2(
                title: widget.mainText,
                content: widget.descripText,
                category: widget.categoryText,
                categoryColor: Colors.blueAccent,
                dateTime: widget.dateTime,
                idGeter: widget.detterId,
              ),
            ),
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<NotesBloc>(),
              child: ShowDeleteDiolog(getId: widget.detterId),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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

          height: 180,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                overflow: TextOverflow.ellipsis,
                widget.mainText,
                maxLines: 1,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                maxLines: 3,
                widget.descripText,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.1,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    widget.dateTime,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight(600),
                      color: Colors.grey,
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 30,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.6, color: Colors.transparent),
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
                    child: Center(
                      child: Text(
                        widget.categoryText,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 69, 100, 240),
                          fontWeight: FontWeight(500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
