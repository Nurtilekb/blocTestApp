// services/card_manager.dart
import 'package:bloctestapp/models/category_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bloctestapp/models/note.dart';

class CardManager {
  Box<Notes> get _notesBox => Hive.box<Notes>('notesBox');
  Box<CategoryModel> get _categoriesBox =>
      Hive.box<CategoryModel>('categoriesBox');

  // ========== ЗАМЕТКИ ==========
  List<Notes> getAllNotes() => _notesBox.values.toList();

  void addNote(Notes note) => _notesBox.put(note.id, note);

  void updateNote(Notes note) => _notesBox.put(note.id, note);

  void deleteNote(String id) => _notesBox.delete(id);

  List<Notes> searchNotes(String query) {
    return _notesBox.values.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void updateNoteCategory(String noteId, int newCategoryId) {
    final note = _notesBox.get(noteId);
    if (note != null) {
      final updatedNote = Notes(
        id: note.id,
        title: note.title,
        description: note.description,
        category: newCategoryId.toString(),
        date: note.date,
      );
      _notesBox.put(noteId, updatedNote);
    }
  }

  // ========== КАТЕГОРИИ ==========
  List<CategoryModel> getAllCategories() {
    final list = _categoriesBox.values.toList();
    list.sort((a, b) => a.id.compareTo(b.id));
    return list;
  }

  CategoryModel? getCategoryById(int id) => _categoriesBox.get(id);

  Future<CategoryModel> createCategory(String name) async {
    final nextId = _categoriesBox.isEmpty
        ? 4
        : _categoriesBox.values
                  .map((c) => c.id)
                  .reduce((a, b) => a > b ? a : b) +
              1;

    final category = CategoryModel(id: nextId, name: name);
    await _categoriesBox.put(category.id, category);
    return category;
  }
}
