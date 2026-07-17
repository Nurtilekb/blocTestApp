import 'package:bloctestapp/models/category_model.dart';

import '../../services/card_manager.dart';
import '../../models/note.dart';

class NotesRepository {
  final CardManager manager;

  NotesRepository(this.manager);

  Future<List<Notes>> getNotes() async {
    return await manager.getAllNotes();
  }

  Future<void> createNote(Notes note) async {
    await manager.addNote(note); // 👈 Исправлено: передаём объект Notes
  }

  Future<void> deleteNote(String id) async {
    await manager.deleteNote(id); // 👈 Исправлено: вызов метода
  }

  Future<void> updateNote(Notes note) async {
    await manager.updateNote(note); // 👈 Исправлено: updateNote вместо updateCard
  }

  Future<List<Notes>> searchNotes(String query) async {
    return await manager.searchNotes(
      query,
    ); // 👈 Исправлено: searchNotes вместо searchCards
  }

  // 👇 ДОБАВИТЬ: работа с категориями
  Future<List<CategoryModel>> getCategories() async {
    return await manager.getAllCategories();
  }

  Future<CategoryModel> createCategory(String name) async {
    return await manager.createCategory(name);
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    return await manager.getCategoryById(id);
  }

  Future<void> updateNoteCategory(String noteId, int newCategoryId) async {
    await manager.updateNoteCategory(noteId, newCategoryId);
  }
}
