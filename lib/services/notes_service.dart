// services/notes_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notes_model.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notesCollection =>
      _firestore.collection('notes').withConverter<Map<String, dynamic>>(
            fromFirestore: (doc, _) => doc.data()!,
            toFirestore: (note, _) => note,
          );

  /// Получить все заметки с обработкой ошибок
  Future<List<Notes>> getAllNotes() async {
    try {
      final snapshot = await _notesCollection.get();
      return snapshot.docs
          .map((doc) => Notes.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Ошибка при загрузке заметок: $e');
    }
  }

  /// Добавить заметку
  Future<void> addNote(Notes note) async {
    try {
      await _notesCollection.doc(note.id).set(note.toJson());
    } catch (e) {
      throw Exception('Ошибка при создании заметки: $e');
    }
  }

  /// Обновить заметку
  Future<void> updateNote(Notes note) async {
    try {
      await _notesCollection
          .doc(note.id)
          .set(note.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Ошибка при обновлении заметки: $e');
    }
  }

  /// Удалить заметку
  Future<void> deleteNote(String id) async {
    try {
      await _notesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Ошибка при удалении заметки: $e');
    }
  }

  /// Поиск заметок
  Future<List<Notes>> searchNotes(String query) async {
    try {
      final lowerQuery = query.toLowerCase();
      final snapshot = await _notesCollection.get();
      return snapshot.docs
          .map((doc) => Notes.fromJson(doc.data()))
          .where(
            (note) =>
                note.title.toLowerCase().contains(lowerQuery) ||
                note.description.toLowerCase().contains(lowerQuery),
          )
          .toList();
    } catch (e) {
      throw Exception('Ошибка при поиске заметок: $e');
    }
  }

  /// Обновить категорию заметки (исправлено: categoryId теперь String)
  Future<void> updateNoteCategory(String noteId, String newCategoryId) async {
    try {
      await _notesCollection.doc(noteId).update({'categoryId': newCategoryId});
    } catch (e) {
      throw Exception('Ошибка при обновлении категории: $e');
    }
  }

  /// Получить заметки по категории
  Future<List<Notes>> getNotesByCategoryId(String categoryId) async {
    try {
      final snapshot = await _notesCollection
          .where('categoryId', isEqualTo: categoryId)
          .get();
      return snapshot.docs
          .map((doc) => Notes.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Ошибка при загрузке заметок по категории: $e');
    }
  }
}
