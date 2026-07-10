import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteDetailPage2 extends StatefulWidget {
  final String title;
  final String content;
  final String category;
  final Color categoryColor;
  final String idGeter;
  final String dateTime;

  const NoteDetailPage2({
    super.key,
    required this.title,
    required this.content,
    required this.category,
    required this.categoryColor,
    required this.dateTime,
    required this.idGeter,
  });

  @override
  State<NoteDetailPage2> createState() => _NoteDetailPage2State();
}

class _NoteDetailPage2State extends State<NoteDetailPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 24),

              _buildTitle(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Категория',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 10),
                  _buildCategoryBadge(),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 18),
              _buildDivider(),
              const SizedBox(height: 10),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  // 👇 Верхняя панель с кнопками
  Widget _buildTopBar(BuildContext context) {
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
        // Кнопка редактировать
        // Кнопка редактировать
        // Кнопка редактировать
        // Кнопка редактировать
        // Кнопка редактировать
        // Кнопка редактировать
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            // Переход на редактирование
          },
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
        // Кнопка удалить
        // Кнопка удалить
        // Кнопка удалить
        // Кнопка удалить
        // Кнопка удалить
        // Кнопка удалить
        // Кнопка удалить
        // Кнопка удалитьs
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            _showDeleteDialog(context, widget.idGeter);
          },
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

  // 👇 Бейдж категории
  Widget _buildCategoryBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 3),
      decoration: BoxDecoration(
        color: widget.categoryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: widget.categoryColor.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 6),
          Text(
            widget.category,
            style: TextStyle(
              fontSize: 14,
              color: widget.categoryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.arrow_drop_down, color: widget.categoryColor),
        ],
      ),
    );
  }

  // 👇 Заголовок
  Widget _buildTitle() {
    return Text(
      widget.title,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: Colors.black,
      ),
    );
  }

  // 👇 Дата создания
  // Widget _buildDate() {
  //   return Row(
  //     children: [
  //       Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[400]),
  //       const SizedBox(width: 6),
  //       Text(
  //         widget.dateTime,
  //         style: TextStyle(
  //           fontSize: 14,
  //           color: Colors.grey[500],
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // 👇 Разделитель
  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(color: Colors.grey[200]),
    );
  }

  // 👇 Контент заметки
  Widget _buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Text(
          widget.content,
          style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey[800]),
        ),
      ),
    );
  }

  // 👇 Диалог подтверждения удаления
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
              Navigator.pop(ctx); // Закрыть диалог
              Navigator.pop(context); // Вернуться назад
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 👇 Форматирование даты
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Только что';
    } else if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes ${_pluralize(minutes, 'минуту', 'минуты', 'минут')} назад';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours ${_pluralize(hours, 'час', 'часа', 'часов')} назад';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${_pluralize(days, 'день', 'дня', 'дней')} назад';
    } else {
      return '${dateTime.day}.${dateTime.month}.${dateTime.year}';
    }
  }

  String _pluralize(int number, String one, String two, String five) {
    final n = number % 100;
    if (n >= 11 && n <= 19) return five;
    final m = n % 10;
    if (m == 1) return one;
    if (m >= 2 && m <= 4) return two;
    return five;
  }
}
