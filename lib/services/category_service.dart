import 'package:bloctestapp/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _firestore.collection('categories').withConverter<Map<String, dynamic>>(
            fromFirestore: (doc, _) => doc.data()!,
            toFirestore: (data, _) => data,
          );

  /// Получить все категории с обработкой ошибок
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _categoriesCollection.orderBy('id').get();
      return snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Ошибка при загрузке категорий: $e');
    }
  }

  /// Получить категорию по ID
  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      final snapshot = await _categoriesCollection
          .where('id', isEqualTo: id)
          .get();
      if (snapshot.docs.isEmpty) return null;
      return CategoryModel.fromJson(snapshot.docs.first.data());
    } catch (e) {
      throw Exception('Ошибка при получении категории: $e');
    }
  }

  /// Удалить категорию
  Future<void> deleteCategory(String id) async {
    try {
      await _categoriesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Ошибка при удалении категории: $e');
    }
  }

  /// Обновить категорию
  Future<void> updateCategory(String id, String newName) async {
    try {
      await _categoriesCollection.doc(id).update({'name': newName});
    } catch (e) {
      throw Exception('Ошибка при обновлении категории: $e');
    }
  }

  /// Создать категорию (исправлено: используем UUID вместо инкремента)
  Future<CategoryModel> createCategory(String name) async {
    try {
      // Генерируем уникальный ID на основе timestamp
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      
      final category = CategoryModel(id: id, name: name);
      await _categoriesCollection.doc(id).set(category.toJson());
      return category;
    } catch (e) {
      throw Exception('Ошибка при создании категории: $e');
    }
  }

  /// Инициализировать категории по умолчанию
  Future<void> initializeDefaultCategories() async {
    try {
      final snapshot = await _categoriesCollection.get();
      if (snapshot.docs.isEmpty) {
        final defaultCategories = [
          CategoryModel(id: '0', name: 'Личное'),
          CategoryModel(id: '1', name: 'Работа'),
          CategoryModel(id: '2', name: 'Идеи'),
          CategoryModel(id: '3', name: 'Важное'),
        ];

        for (final cat in defaultCategories) {
          await _categoriesCollection.doc(cat.id).set(cat.toJson());
        }
      }
    } catch (e) {
      throw Exception('Ошибка при инициализации категорий: $e');
    }
  }
}
