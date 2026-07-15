import 'package:flutter/material.dart';

class DetailTitleField extends StatelessWidget {
  final bool isEditing;
  final TextEditingController controller;
  final String title;

  const DetailTitleField({
    super.key,
    required this.isEditing,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return isEditing
        ? TextField(
            cursorColor: Theme.of(context).primaryColor,
            autofocus: true,
            cursorHeight: 30,
            decoration: const InputDecoration(
              hintText: 'Введите заголовок...',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            controller: controller,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: Colors.black,
            ),
          )
        : Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: Colors.black,
            ),
          );
  }
}