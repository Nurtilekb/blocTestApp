import 'package:flutter/material.dart';

class DetailContentField extends StatelessWidget {
  final bool isEditing;
  final TextEditingController controller;
  final String content;

  const DetailContentField({
    super.key,
    required this.isEditing,
    required this.controller,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: isEditing
            ? TextField(
                cursorHeight: 20,
                cursorColor: Theme.of(context).primaryColor,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                controller: controller,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[800],
                ),
              )
            : Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[800],
                ),
              ),
      ),
    );
  }
}