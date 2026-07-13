import 'package:bloctestapp/widgets/app_input_widget.dart';
import 'package:flutter/material.dart';

class Showdiolog extends StatefulWidget {
  Showdiolog({super.key});

  @override
  State<Showdiolog> createState() => _ShowdiologState();
}

class _ShowdiologState extends State<Showdiolog> {
  // final _formKey = GlobalKey<FormState>();
  // final _titleController = TextEditingController();
  // final _contentController = TextEditingController();
  // int _selectedCategory = 0;

  // final List<Map<String, dynamic>> _categories = [
  //   {
  //     'id': 0,
  //     'name': 'Личное',
  //     'icon': Icons.person,
  //     'color': Color(0xFF007AFF),
  //   },
  //   {'id': 1, 'name': 'Работа', 'icon': Icons.work, 'color': Color(0xFF34C759)},
  //   {
  //     'id': 2,
  //     'name': 'Идеи',
  //     'icon': Icons.lightbulb,
  //     'color': Color(0xFFFF9500),
  //   },
  //   {'id': 3, 'name': 'Важное', 'icon': Icons.star, 'color': Color(0xFFFF3B30)},
  // ];

  // @override
  // void dispose() {
  //   _titleController.dispose();
  //   _contentController.dispose();
  //   super.dispose();
  // }

  // 👇 Метод для показа диалога

  // 👇 Сам Bottom Sheet
  Widget _buildBottomSheet(BuildContext context, Key? _formKey) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Индикатор
              Center(
                child: Container(
                  child: Text('qfqwergsaerefgbhtgwerfgtrwerfgtb'),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Категории
              Text(
                'Категория',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),

              ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [const SizedBox(width: 4), Text('name')],
                ),

                onSelected: (selected) {
                  setState(() {});
                },
                labelStyle: TextStyle(color: Colors.black),
                selected: true,
              ),

              const SizedBox(height: 24),

              // Кнопка сохранения
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Сохранить',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // 👈 этот виджет не используется напрямую
  }
}

// 👇 Использование:
// final dialog = Showdiolog(
//   onSave: (title, content, category) {
//     print('$title, $content, $category');
//   },
// );
// dialog.show(context);
