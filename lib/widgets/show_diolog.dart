// import 'package:bloctestapp/widgets/app_input_widget.dart';
// import 'package:flutter/material.dart';

// class Showdiolog extends StatefulWidget {
//   final Function(String title, String content, int category)? onSave;
//   const Showdiolog({super.key, this.onSave});

//   @override
//   State<Showdiolog> createState() => _ShowdiologState();
// }

// class _ShowdiologState extends State<Showdiolog> {
//   // final _formKey = GlobalKey<FormState>();
//   // final _titleController = TextEditingController();
//   // final _contentController = TextEditingController();
//   // int _selectedCategory = 0;

//   // final List<Map<String, dynamic>> _categories = [
//   //   {
//   //     'id': 0,
//   //     'name': 'Личное',
//   //     'icon': Icons.person,
//   //     'color': Color(0xFF007AFF),
//   //   },
//   //   {'id': 1, 'name': 'Работа', 'icon': Icons.work, 'color': Color(0xFF34C759)},
//   //   {
//   //     'id': 2,
//   //     'name': 'Идеи',
//   //     'icon': Icons.lightbulb,
//   //     'color': Color(0xFFFF9500),
//   //   },
//   //   {'id': 3, 'name': 'Важное', 'icon': Icons.star, 'color': Color(0xFFFF3B30)},
//   // ];

//   // @override
//   // void dispose() {
//   //   _titleController.dispose();
//   //   _contentController.dispose();
//   //   super.dispose();
//   // }

//   // 👇 Метод для показа диалога
//   void show(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => _buildBottomSheet(context),
//     );
//   }

//   // 👇 Сам Bottom Sheet
//   Widget _buildBottomSheet(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//         ),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Индикатор
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Заголовок
//               AppInputWidget(
//                 controller: _titleController,
//                 hintText: 'Введите заголовок...',
//               ),
//               const SizedBox(height: 12),

//               // Контент
//               AppInputWidget(
//                 controller: _contentController,
//                 hintText: 'Введите описание...',
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 20),

//               // Категории
//               Text(
//                 'Категория',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Wrap(
//                 spacing: 8,
//                 children: _categories.map((category) {
//                   final isSelected = _selectedCategory == category['id'];
//                   return ChoiceChip(
//                     label: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           category['icon'],
//                           size: 16,
//                           color: isSelected ? Colors.white : category['color'],
//                         ),
//                         const SizedBox(width: 4),
//                         Text(category['name']),
//                       ],
//                     ),
//                     selected: isSelected,
//                     selectedColor: category['color'],
//                     onSelected: (selected) {
//                       setState(() {
//                         _selectedCategory = category['id'];
//                       });
//                     },
//                     labelStyle: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black,
//                     ),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 24),

//               // Кнопка сохранения
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       widget.onSave?.call(
//                         _titleController.text,
//                         _contentController.text,
//                         _selectedCategory,
//                       );
//                       Navigator.pop(context);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     backgroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   child: const Text(
//                     'Сохранить',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox.shrink(); // 👈 этот виджет не используется напрямую
//   }
// }

// // 👇 Использование:
// // final dialog = Showdiolog(
// //   onSave: (title, content, category) {
// //     print('$title, $content, $category');
// //   },
// // );
// // dialog.show(context);
