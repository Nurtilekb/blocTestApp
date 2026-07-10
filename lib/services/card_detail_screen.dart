// import 'package:bloctestapp/models/card_manager.dart';
// import 'package:bloctestapp/models/user.dart';
// import 'package:flutter/material.dart';

// import 'card_create_screen.dart';

// class CardDetailScreen extends StatefulWidget {
//   final Notes card;

//   const CardDetailScreen({Key? key, required this.card}) : super(key: key);

//   @override
//   _CardDetailScreenState createState() => _CardDetailScreenState();
// }

// class _CardDetailScreenState extends State<CardDetailScreen> {
//   final CardManager _cardManager = CardManager();
//   late Notes _card;

//   @override
//   void initState() {
//     super.initState();
//     _card = widget.card;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_card.title),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(icon: Icon(Icons.edit), onPressed: _editCard),
//           IconButton(icon: Icon(Icons.delete), onPressed: _deleteCard),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Заголовок
//             Text(
//               _card.title,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),

//             // Категория
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.blue[100],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 _card.category,
//                 style: TextStyle(color: Colors.blue[800]),
//               ),
//             ),
//             SizedBox(height: 16),

//             // Описание
//             Text(
//               'Описание:',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[700],
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(_card.description, style: TextStyle(fontSize: 16)),
//             SizedBox(height: 16),

//             // Дата
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, color: Colors.grey),
//                 SizedBox(width: 8),
//                 Text(
//                   'Создано: ${_card.date.toString().substring(0, 10)}',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),

//             // Избранное
//             Row(
//               children: [
//                 Icon(Icons.star_border, color: Colors.grey),
//                 SizedBox(width: 8),
//                 Text(
//                   'Не в избранном',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ],
//             ),

//             // Теги
//             // if (_card.tags != null && _card.tags!.isNotEmpty) ...[
//             //   SizedBox(height: 16),
//             //   Text(
//             //     'Теги:',
//             //     style: TextStyle(
//             //       fontSize: 16,
//             //       fontWeight: FontWeight.bold,
//             //       color: Colors.grey[700],
//             //     ),
//             //   ),
//             //   SizedBox(height: 8),
//             //   Wrap(
//             //     spacing: 8,
//             //     children: _card.tags!.map((tag) => Chip(label: Text(tag))).toList(),
//             //   ),
//             // ],
//             Spacer(),

//             // Кнопки действий
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _toggleFavorite,
//                     label: Text('В избранное'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _deleteCard,
//                     icon: Icon(Icons.delete),
//                     label: Text('Удалить'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Переключение избранного
//   void _toggleFavorite() {
//     setState(() {
//       // _cardManager.toggleFavorite(_card.id);
//       // _card = _card.copyWith(isFavorite: !_card.isFavorite);
//     });
//   }

//   // Редактирование карточки
//   void _editCard() async {
//     // Здесь можно открыть экран редактирования
//     // Для простоты показываем диалог
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Редактирование'),
//         content: Text('Функция редактирования будет добавлена'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Закрыть'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Удаление карточки
//   void _deleteCard() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Удалить карточку?'),
//         content: Text('Вы уверены, что хотите удалить "${_card.title}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Отмена'),
//           ),
//           TextButton(
//             onPressed: () {
//               _cardManager.deleteCard(_card.id);
//               Navigator.pop(context);
//               Navigator.pop(context, true);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('🗑️ Карточка удалена'),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             },
//             child: Text('Удалить', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }
