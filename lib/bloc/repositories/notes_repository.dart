import 'package:bloctestapp/models/category_model.dart';

import '../../services/card_services.dart';
import '../../models/note.dart';

class NotesRepository {
  final CardManager manager;

  NotesRepository(this.manager);

  List<Notes> getNotes() {
    return manager.getAllNotes();
  }

  void createNote(Notes note) {
    manager.addNote(note);
  }

  void deleteNote(String id) {
    manager.deleteNote(id);
  }

  void updateNote(Notes note) {
    manager.updateNote(note);
  }

  List<Notes> searchNotes(String query) {
    return manager.searchNotes(query);
  }

  List<CategoryModel> getCategories() {
    return manager.getAllCategories();
  }

  Future<CategoryModel> createCategory(String name) async {
    return manager.createCategory(name);
  }

  CategoryModel? getCategoryById(int id) {
    return manager.getCategoryById(id);
  }

  void updateNoteCategory(String noteId, int newCategoryId) {
    manager.updateNoteCategory(noteId, newCategoryId);
  }

  void deleteCategory(int id) {
    manager.deleteCategory(id);
  }

  void updateCategory(int id, String newName) {
    manager.updateCategory(id, newName);
  }
}
