import 'package:bloctestapp/models/category_model.dart';
import 'package:bloctestapp/services/category_service.dart';
import 'package:bloctestapp/services/notes_service.dart';

import '../../models/notes_model.dart';

/// Repository слой для абстракции работы с данными
class NotesRepository {
  final NotesService notesService;
  final CategoryService categoryService;

  NotesRepository(this.notesService, this.categoryService);

  /// ЗАМЕТКИ ///

  Future<List<Notes>> getNotes() async {
    return await notesService.getAllNotes();
  }

  Future<void> createNote(Notes note) async {
    await notesService.addNote(note);
  }

  Future<void> deleteNote(String id) async {
    await notesService.deleteNote(id);
  }

  Future<void> updateNote(Notes note) async {
    await notesService.updateNote(note);
  }

  Future<void> updateNoteCategory(String noteId, String newCategoryId) async {
    await notesService.updateNoteCategory(noteId, newCategoryId);
  }

  Future<List<Notes>> searchNotes(String query) async {
    return await notesService.searchNotes(query);
  }

  Future<List<Notes>> getNotesByCategoryId(String categoryId) async {
    return await notesService.getNotesByCategoryId(categoryId);
  }

  /// КАТЕГОРИИ ///

  Future<List<CategoryModel>> getCategories() async {
    return await categoryService.getAllCategories();
  }

  Future<CategoryModel> createCategory(String name) async {
    return await categoryService.createCategory(name);
  }

  Future<void> deleteCategory(String id) async {
    await categoryService.deleteCategory(id);
  }

  Future<void> updateCategory(String id, String newName) async {
    await categoryService.updateCategory(id, newName);
  }

  Future<CategoryModel?> getCategoryById(String id) async {
    return await categoryService.getCategoryById(id);
  }
}
