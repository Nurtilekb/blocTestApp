// services/category_service.dart
import 'package:bloctestapp/models/category_model.dart';
import 'firestore_service.dart';

class CategoryService {
  final FirestoreService _firestoreService;

  CategoryService(this._firestoreService);

  // 👇 Дефолтные категории (инициализация через Firestore)
  static final List _defaults = [
    CategoryModel(id: 0, name: 'Личное'),
    CategoryModel(id: 1, name: 'Работа'),
    CategoryModel(id: 2, name: 'Идеи'),
    CategoryModel(id: 3, name: 'Важное'),
  ];

  Future<void> ensureDefaults() async {
    await _firestoreService.initializeDefaultCategories();
  }

  // 👇 Создать новую категорию
  Future<CategoryModel> createCategory(String name) async {
    return await _firestoreService.createCategory(name);
  }

  // 👇 Получить все категории
  Future<List<CategoryModel>> getAllCategories() async {
    return await _firestoreService.getAllCategories();
  }

  // 👇 Получить категорию по id
  Future<CategoryModel?> getCategoryById(int id) async {
    return await _firestoreService.getCategoryById(id);
  }
}
