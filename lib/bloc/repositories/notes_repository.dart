import 'package:bloctestapp/models/category_model.dart';

import '../../services/card_manager.dart';
import '../../models/note.dart';

class NotesRepository {
  final CardManager manager;

  NotesRepository(this.manager);

  List<Notes> getNotes() {
    return manager.getAllNotes();
  }

  void createNote(Notes note) {
    manager.addNote(note); // 👈 Исправлено: передаём объект Notes
  }

  void deleteNote(String id) {
    manager.deleteNote(id); // 👈 Исправлено: вызов метода
  }

  void updateNote(Notes note) {
    manager.updateNote(note); // 👈 Исправлено: updateNote вместо updateCard
  }

  List<Notes> searchNotes(String query) {
    return manager.searchNotes(
      query,
    ); // 👈 Исправлено: searchNotes вместо searchCards
  }

  // 👇 ДОБАВИТЬ: работа с категориями
  List<CategoryModel> getCategories() {
    return manager.getAllCategories();
  }

  Future<CategoryModel> createCategory(String name) {
    return manager.createCategory(name);
  }

  CategoryModel? getCategoryById(int id) {
    return manager.getCategoryById(id);
  }

  void updateNoteCategory(String noteId, int newCategoryId) {
    manager.updateNoteCategory(noteId, newCategoryId);
  }
}
