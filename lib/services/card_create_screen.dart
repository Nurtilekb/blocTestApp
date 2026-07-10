// import 'package:bloctestapp/models/card_manager.dart';
// import 'package:flutter/material.dart';

// class CardCreateScreen extends StatefulWidget {
//   @override
//   _CardCreateScreenState createState() => _CardCreateScreenState();
// }

// class _CardCreateScreenState extends State<CardCreateScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _cardManager = CardManager();

//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _categoryController = TextEditingController();

//   DateTime _selectedDate = DateTime.now();
//   bool _isFavorite = false;
//   List<String> _tags = [];
//   final _tagController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Создать карточку'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Название
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   labelText: 'Название *',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.title),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Введите название';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),

//               // Описание
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(
//                   labelText: 'Описание *',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.description),
//                 ),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Введите описание';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),

//               // Категория
//               TextFormField(
//                 controller: _categoryController,
//                 decoration: InputDecoration(
//                   labelText: 'Категория *',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.category),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Введите категорию';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),

//               // Дата
//               ListTile(
//                 title: Text('Дата'),
//                 subtitle: Text(_selectedDate.toString().substring(0, 10)),
//                 leading: Icon(Icons.calendar_today),
//                 onTap: _selectDate,
//               ),
//               SizedBox(height: 16),

//               // Избранное
//               SwitchListTile(
//                 title: Text('Добавить в избранное'),
//                 value: _isFavorite,
//                 onChanged: (value) {
//                   setState(() {
//                     _isFavorite = value;
//                   });
//                 },
//                 activeColor: Colors.amber,
//               ),
//               SizedBox(height: 16),

//               // Теги
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _tagController,
//                       decoration: InputDecoration(
//                         labelText: 'Добавить тег',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.tag),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   ElevatedButton(onPressed: _addTag, child: Text('+')),
//                 ],
//               ),
//               if (_tags.isNotEmpty)
//                 Wrap(
//                   spacing: 8,
//                   children: _tags
//                       .map(
//                         (tag) => Chip(
//                           label: Text(tag),
//                           onDeleted: () => _removeTag(tag),
//                         ),
//                       )
//                       .toList(),
//                 ),
//               SizedBox(height: 24),

//               // Кнопка создания
//               ElevatedButton(
//                 onPressed: _saveCard,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   child: Text(
//                     'Создать карточку',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Выбор даты
//   Future<void> _selectDate() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );

//     if (date != null) {
//       setState(() {
//         _selectedDate = date;
//       });
//     }
//   }

//   // Добавление тега
//   void _addTag() {
//     if (_tagController.text.isNotEmpty) {
//       setState(() {
//         _tags.add(_tagController.text);
//         _tagController.clear();
//       });
//     }
//   }

//   // Удаление тега
//   void _removeTag(String tag) {
//     setState(() {
//       _tags.remove(tag);
//     });
//   }

//   // Сохранение карточки
//   void _saveCard() {
//     if (_formKey.currentState!.validate()) {
//       _cardManager.createCard(
//         title: _titleController.text,
//         description: _descriptionController.text,
//         category: _categoryController.text,
//         date: _selectedDate,
//         isFavorite: _isFavorite,
//         tags: _tags.isNotEmpty ? _tags : null,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('✅ Карточка создана!'),
//           backgroundColor: Colors.green,
//         ),
//       );

//       Navigator.pop(context, true);
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _categoryController.dispose();
//     _tagController.dispose();
//     super.dispose();
//   }
// }
