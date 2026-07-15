import 'package:flutter/material.dart';

// 👇 Импортируем дефолтные категории
const List<Map<String, dynamic>> defaultCategories = [
  {'name': 'Личное', 'color': Color(0xFF007AFF), 'icon': Icons.person},
  {'name': 'Работа', 'color': Color(0xFF34C759), 'icon': Icons.work},
  {'name': 'Идеи', 'color': Color(0xFFFF9500), 'icon': Icons.lightbulb},
  {'name': 'Важное', 'color': Color(0xFFFF3B30), 'icon': Icons.star},
];

class CategoryItem extends StatelessWidget {
  final String categName;
  final String noteId;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.categName,
    required this.noteId,
    required this.onTap,
  });

  // 👇 Получаем цвет категории
  Color _getCategoryColor() {
    final found = defaultCategories.firstWhere(
      (cat) => cat['name'] == categName,
      orElse: () => {'color': Colors.teal},
    );
    return found['color'] as Color;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15), // 👈 цвет зависит от категории
          borderRadius: BorderRadius.circular(10),
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
        ),
        child: Center(
          child: Text(
            categName,
            style: TextStyle(
              fontSize: 14,
              color: color, // 👈 цвет текста как у категории
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}