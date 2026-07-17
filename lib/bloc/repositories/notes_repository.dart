import 'package:bloctestapp/models/category_model.dart';
import 'package:bloctestapp/services/firestrore_service.dart';

import '../../models/note.dart';

class NotesRepository {
  final FirestoreService manager;

  NotesRepository(this.manager);

  Future<List<Notes>> getNotes() async {
    return await manager.getAllNotes();
  }

  Future<void> createNote(Notes note) async {
    await manager.addNote(note);
  }

  Future<void> deleteNote(String id) async {
    await manager.deleteNote(id);
  }

  Future<void> updateNote(Notes note) async {
    await manager.updateNote(note);
  }

  Future<List<CategoryModel>> getCategories() async {
    return await manager.getAllCategories();
  }

  Future<CategoryModel> createCategory(String name) async {
    return await manager.createCategory(name);
  }

  Future<void> deleteCategory(int id) async {
    await manager.deleteCategory(id);
  }

  Future<void> updateCategory(int id, String newName) async {
    await manager.updateCategory(id, newName);
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    return await manager.getCategoryById(id);
  }

  Future<void> updateNoteCategory(String noteId, int newCategoryId) async {
    await manager.updateNoteCategory(noteId, newCategoryId);
  }

  Future<List<Notes>> searchNotes(String query) async {
    return await manager.searchNotes(query);
  }
}
