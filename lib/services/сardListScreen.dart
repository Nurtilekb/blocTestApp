// import 'package:bloctestapp/models/card_manager.dart';
// import 'package:bloctestapp/models/user.dart';
// import 'package:bloctestapp/services/card_create_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// class CardListScreen extends StatefulWidget {
//   @override
//   _CardListScreenState createState() => _CardListScreenState();
// }

// class _CardListScreenState extends State<CardListScreen> {
//   final CardManager _cardManager = CardManager();
//   String _searchQuery = '';
//   String? _selectedCategory;

//   // Получаем все категории
//   List<String> get _categories {
//     final cards = _cardManager.getAllCards();
//     return cards.map((c) => c.category).toSet().toList();
//   }

//   // Фильтруем карточки
//   List<Notes> get _filteredCards {
//     var cards = _cardManager.getAllCards();

//     // Фильтр по поиску
//     if (_searchQuery.isNotEmpty) {
//       cards = cards
//           .where(
//             (card) =>
//                 card.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//                 card.description.toLowerCase().contains(
//                   _searchQuery.toLowerCase(),
//                 ),
//           )
//           .toList();
//     }

//     // Фильтр по категории
//     if (_selectedCategory != null) {
//       cards = cards
//           .where((card) => card.category == _selectedCategory)
//           .toList();
//     }

//     // Сортировка по дате (новые сверху)
//     cards.sort((a, b) => b.date.compareTo(a.date));

//     return cards;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Мои карточки (${_filteredCards.length})'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         actions: [
//           // Кнопка статистики
//           IconButton(icon: Icon(Icons.stars), onPressed: _showStatistics),
//           // Кнопка удаления всех
//           IconButton(
//             icon: Icon(Icons.delete_sweep),
//             onPressed: _confirmDeleteAll,
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(60),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 // Поиск
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Поиск...',
//                       prefixIcon: Icon(Icons.search),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _searchQuery = value;
//                       });
//                     },
//                   ),
//                 ),
//                 // Фильтр по категории
//                 if (_categories.isNotEmpty)
//                   PopupMenuButton<String>(
//                     icon: Icon(Icons.filter_list, color: Colors.white),
//                     onSelected: (value) {
//                       setState(() {
//                         _selectedCategory = value == 'all' ? null : value;
//                       });
//                     },
//                     itemBuilder: (context) => [
//                       PopupMenuItem(value: 'all', child: Text('Все категории')),
//                       ..._categories.map(
//                         (category) => PopupMenuItem(
//                           value: category,
//                           child: Text(category),
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: _filteredCards.isEmpty ? _buildEmptyState() : _buildCardList(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => CardCreateScreen()),
//           );
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }

//   // Пустое состояние
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.inbox, size: 80, color: Colors.grey),
//           SizedBox(height: 20),
//           Text(
//             'Нет карточек',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Нажмите кнопку "+" чтобы создать первую карточку',
//             style: TextStyle(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }

//   // Список карточек
//   Widget _buildCardList() {
//     return ListView.builder(
//       padding: EdgeInsets.all(16),
//       itemCount: _filteredCards.length,
//       itemBuilder: (context, index) {
//         final card = _filteredCards[index];
//         return Card(
//           margin: EdgeInsets.only(bottom: 12),
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: InkWell(
//             onTap: () {},
//             borderRadius: BorderRadius.circular(12),
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Верхняя строка: заголовок и избранное
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           card.title,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.star_border, color: Colors.amber),
//                         onPressed: () {
//                           setState(() {});
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   // Описание
//                   Text(
//                     card.description,
//                     style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 12),
//                   // Нижняя строка: категория и дата
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.blue[100],
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           card.category,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.blue[800],
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       Text(
//                         _formatDate(card.date),
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                   // Теги (если есть)
//                   // if (card.tags != null && card.tags!.isNotEmpty)
//                   // Padding(
//                   //   padding: EdgeInsets.only(top: 8),
//                   //   child: Wrap(
//                   //     spacing: 4,
//                   //     children:
//                   //     card.tags!
//                   //         .map(
//                   //           (tag) => Chip(
//                   //             label: Text(tag),
//                   //             labelStyle: TextStyle(fontSize: 10),
//                   //             padding: EdgeInsets.symmetric(horizontal: 4),
//                   //             materialTapTargetSize:
//                   //                 MaterialTapTargetSize.shrinkWrap,
//                   //           ),
//                   //         )
//                   //         .toList(),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Форматирование даты
//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);

//     if (difference.inDays == 0) {
//       return 'Сегодня';
//     } else if (difference.inDays == 1) {
//       return 'Вчера';
//     } else if (difference.inDays < 7) {
//       return '${difference.inDays} дня(ей) назад';
//     } else {
//       return '${date.day}.${date.month}.${date.year}';
//     }
//   }

//   // Показать статистику
//   void _showStatistics() {
//     final stats = _cardManager.getStatistics();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Статистика'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('📊 Всего карточек: ${stats['total']}'),
//             Text('⭐ Избранные: ${stats['favorites']}'),
//             Text('🏷️ Категорий: ${stats['categories']}'),
//             Text('🆕 За неделю: ${stats['recent']}'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Закрыть'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Подтверждение удаления всех карточек
//   void _confirmDeleteAll() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Удалить все?'),
//         content: Text('Вы уверены, что хотите удалить все карточки?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Отмена'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _cardManager.deleteAllCards();
//                 Navigator.pop(context);
//               });
//             },
//             child: Text('Удалить', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }
