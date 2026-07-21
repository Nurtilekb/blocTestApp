import 'package:bloctestapp/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _categoriesCollection =>
      _firestore.collection('categories');

  Future<List<CategoryModel>> getAllCategories() async {
    final snapshot = await _categoriesCollection.orderBy('id').get();
    return snapshot.docs
        .map(
          (doc) => CategoryModel.fromJson(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    final snapshot = await _categoriesCollection
        .where('id', isEqualTo: id)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return CategoryModel.fromJson(
      snapshot.docs.first.data() as Map<String, dynamic>,
    );
  }

  Future<void> deleteCategory(int id) async {
    await _categoriesCollection.doc(id.toString()).delete();
  }

  Future<void> updateCategory(int id, String newName) async {
    await _categoriesCollection.doc(id.toString()).update({'name': newName});
  }

  Future<CategoryModel> createCategory(String name) async {
    final snapshot = await _categoriesCollection
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    int nextId;
    if (snapshot.docs.isEmpty) {
      nextId = 4;
    } else {
      final lastCategory = CategoryModel.fromJson(
        snapshot.docs.first.data() as Map<String, dynamic>,
      );
      nextId = lastCategory.id + 1;
    }

    final category = CategoryModel(id: nextId, name: name);
    await _categoriesCollection.doc(nextId.toString()).set(category.toJson());
    return category;
  }

  Future<void> initializeDefaultCategories() async {
    final snapshot = await _categoriesCollection.get();
    if (snapshot.docs.isEmpty) {
      final defaultCategories = [
        CategoryModel(id: 0, name: 'Личное'),
        CategoryModel(id: 1, name: 'Работа'),
        CategoryModel(id: 2, name: 'Идеи'),
        CategoryModel(id: 3, name: 'Важное'),
      ];

      for (final cat in defaultCategories) {
        await _categoriesCollection.doc(cat.id.toString()).set(cat.toJson());
      }
    }
  }
}
