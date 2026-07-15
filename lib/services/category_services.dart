// services/category_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bloctestapp/models/category_model.dart';

class CategoryService {
  final Box<CategoryModel> _box;

  CategoryService(this._box) {
    _ensureDefaults();
  }

  // 👇 Дефолтные категории
  static final List _defaults = [
    CategoryModel(id: 0, name: 'Личное'),
    CategoryModel(id: 1, name: 'Работа'),
    CategoryModel(id: 2, name: 'Идеи'),
    CategoryModel(id: 3, name: 'Важное'),
  ];

  void _ensureDefaults() {
    if (_box.isEmpty) {
      for (final cat in _defaults) {
        _box.put(cat.id, cat);
      }
    }
  }

  // 👇 Создать новую категорию
  Future<CategoryModel> createCategory(String name) async {
    final nextId = _box.isEmpty
        ? 4
        : _box.values.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;

    final category = CategoryModel(id: nextId, name: name);
    await _box.put(category.id, category);
    return category;
  }

  // 👇 Получить все категории
  List<CategoryModel> getAllCategories() {
    final list = _box.values.toList();
    list.sort((a, b) => a.id.compareTo(b.id));
    return list;
  }

  // 👇 Получить категорию по id
  CategoryModel? getCategoryById(int id) {
    return _box.get(id);
  }
}
