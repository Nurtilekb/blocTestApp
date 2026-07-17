// services/card_manager.dart
import 'package:bloctestapp/models/category_model.dart';
import 'package:bloctestapp/models/note.dart';
import 'firestore_service.dart';

class CardManager {
  final FirestoreService _firestoreService = FirestoreService();

  // ========== ЗАМЕТКИ ==========
  Future<List<Notes>> getAllNotes() async {
    return await _firestoreService.getAllNotes();
  }

  Future<void> addNote(Notes note) async {
    await _firestoreService.addNote(note);
  }

  Future<void> updateNote(Notes note) async {
    await _firestoreService.updateNote(note);
  }

  Future<void> deleteNote(String id) async {
    await _firestoreService.deleteNote(id);
  }

  Future<List<Notes>> searchNotes(String query) async {
    return await _firestoreService.searchNotes(query);
  }

  Future<void> updateNoteCategory(String noteId, int newCategoryId) async {
    await _firestoreService.updateNoteCategory(noteId, newCategoryId);
  }

  // ========== КАТЕГОРИИ ==========
  Future<List<CategoryModel>> getAllCategories() async {
    return await _firestoreService.getAllCategories();
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    return await _firestoreService.getCategoryById(id);
  }

  Future<CategoryModel> createCategory(String name) async {
    return await _firestoreService.createCategory(name);
  }

  Future<void> initializeDefaultCategories() async {
    await _firestoreService.initializeDefaultCategories();
  }
}
