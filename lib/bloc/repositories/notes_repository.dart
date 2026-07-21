import 'package:bloctestapp/models/category_model.dart';
import 'package:bloctestapp/services/category_service.dart';
import 'package:bloctestapp/services/notes_service.dart';

import '../../models/notes_model.dart';

class NotesRepository {
  final NotesService manager;
  final CategoryService manager2;

  NotesRepository(this.manager, this.manager2);

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

  Future<void> updateNoteCategory(String noteId, int newCategoryId) async {
    await manager.updateNoteCategory(noteId, newCategoryId);
  }

  Future<List<Notes>> searchNotes(String query) async {
    return await manager.searchNotes(query);
  }

  Future<List<Notes>> getNotesByCategoryId(String categoryId) async {
    return await manager.getNotesByCategoryId(categoryId);
  }

  /// /////////////////////////////////////////////////////////////////////////////////////////////////
  /// For Category

  Future<List<CategoryModel>> getCategories() async {
    return await manager2.getAllCategories();
  }

  Future<CategoryModel> createCategory(String name) async {
    return await manager2.createCategory(name);
  }

  Future<void> deleteCategory(int id) async {
    await manager2.deleteCategory(id);
  }

  Future<void> updateCategory(int id, String newName) async {
    await manager2.updateCategory(id, newName);
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    return await manager2.getCategoryById(id);
  }
}
