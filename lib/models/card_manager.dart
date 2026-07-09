import 'package:bloctestapp/models/user.dart';
import 'package:hive/hive.dart';
import 'dart:math';

class CardManager {
  // Получаем коробку
  final Box<Notes> cardsBox = Hive.box<Notes>('cardsBox');

  // Генерация уникального ID
  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // СОЗДАНИЕ карточки
  void createCard({
    required String title,
    required String description,
    required String category,
    DateTime? date,
    bool isFavorite = false,
    String? imageUrl,
    List<String>? tags,
  }) {
    final card = Notes(
      id: generateId(),
      title: title,
      description: description,
      category: category,
      date: date ?? DateTime.now(),
    );

    cardsBox.put(card.id, card);
    print('✅ Карточка создана: ${card.title}');
  }

  // ПОЛУЧЕНИЕ всех карточек
  List<Notes> getAllCards() {
    return cardsBox.values.toList();
  }

  // ПОЛУЧЕНИЕ карточки по ID
  Notes? getCardById(String id) {
    return cardsBox.get(id);
  }

  // ОБНОВЛЕНИЕ карточки
  void updateCard(Notes updatedCard) {
    cardsBox.put(updatedCard.id, updatedCard);
    print('✅ Карточка обновлена: ${updatedCard.title}');
  }

  // УДАЛЕНИЕ карточки
  void deleteCard(String id) {
    cardsBox.delete(id);
    print('🗑️ Карточка удалена: $id');
  }

  // УДАЛЕНИЕ всех карточек
  void deleteAllCards() {
    cardsBox.clear();
    print('🗑️ Все карточки удалены');
  }

  // ФИЛЬТРАЦИЯ по категории
  List<Notes> getCardsByCategory(String category) {
    return cardsBox.values.where((card) => card.category == category).toList();
  }

  // ПОИСК по названию или описанию
  List<Notes> searchCards(String query) {
    if (query.isEmpty) return getAllCards();

    return cardsBox.values
        .where(
          (card) =>
              card.title.toLowerCase().contains(query.toLowerCase()) ||
              card.description.toLowerCase().contains(query.toLowerCase()) ||
              card.category.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  // ПОЛУЧЕНИЕ карточек по диапазону дат
  List<Notes> getCardsByDateRange(DateTime start, DateTime end) {
    return cardsBox.values
        .where((card) => card.date.isAfter(start) && card.date.isBefore(end))
        .toList();
  }

  // ГРУППИРОВКА по категориям
  Map<String, List<Notes>> groupCardsByCategory() {
    final Map<String, List<Notes>> grouped = {};

    for (var card in cardsBox.values) {
      if (!grouped.containsKey(card.category)) {
        grouped[card.category] = [];
      }
      grouped[card.category]!.add(card);
    }

    return grouped;
  }

  // ПОЛУЧЕНИЕ статистики
  Map<String, dynamic> getStatistics() {
    final allCards = getAllCards();
    final categories = allCards.map((c) => c.category).toSet();

    return {
      'total': allCards.length,
      'categories': categories.length,
      'recent': allCards
          .where(
            (c) => c.date.isAfter(DateTime.now().subtract(Duration(days: 7))),
          )
          .length,
    };
  }
}
