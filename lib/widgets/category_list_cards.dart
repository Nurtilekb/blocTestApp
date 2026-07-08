import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  CategoryCard({
    super.key,
    required this.nameCategory,
    required this.isSelected,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
  final String nameCategory;
  bool isSelected;
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        border: Border.all(width: 0.3),
        color: widget.isSelected
            ? Theme.of(
                    context,
                  ).elevatedButtonTheme.style!.backgroundColor?.resolve({}) ??
                  Theme.of(context).colorScheme.primary
            : Colors.white,
        borderRadius: BorderRadius.circular(25),
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
          widget.nameCategory,
          style: TextStyle(
            fontSize: 14,
            color: widget.isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight(600),
          ),
        ),
      ),
    );
  }
}
