import 'package:flutter/material.dart';

/// Дефолтные категории
const defaultCategories = [
  {'name': 'Личное', 'color': Color(0xFF007AFF), 'icon': Icons.person},
  {'name': 'Работа', 'color': Color(0xFF34C759), 'icon': Icons.work},
  {'name': 'Идеи', 'color': Color(0xFFFF9500), 'icon': Icons.lightbulb},
  {'name': 'Важное', 'color': Color(0xFFFF3B30), 'icon': Icons.star},
];

/// Названия дефолтных категорий
const defaultCategoryNames = ['Личное', 'Работа', 'Идеи', 'Важное'];

/// Общие стили для карточек
BoxDecoration cardDecoration = BoxDecoration(
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
);

/// Получить цвет категории по названию
Color getCategoryColor(String name) {
  final found = defaultCategories.firstWhere(
    (cat) => cat['name'] == name,
    orElse: () => {'color': const Color.fromARGB(255, 88, 55, 105)},
  );
  return found['color'] as Color;
}

/// Получить иконку категории по названию
IconData getCategoryIcon(String name) {
  final found = defaultCategories.firstWhere(
    (cat) => cat['name'] == name,
    orElse: () => {'icon': Icons.folder},
  );
  return found['icon'] as IconData;
}
