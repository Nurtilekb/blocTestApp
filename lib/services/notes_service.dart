// services/notes_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notes_model.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  CollectionReference<Map<String, dynamic>> get _notesCollection =>
      _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('notes')
          .withConverter<Map<String, dynamic>>(
            fromFirestore: (doc, _) => doc.data()!,
            toFirestore: (note, _) => note,
          );

  /// Получить все заметки с обработкой ошибок
  Future<List<Notes>> getAllNotes() async {
    if (_currentUserId.isEmpty) return [];
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
    if (_currentUserId.isEmpty) {
      throw Exception('Пользователь не авторизован');
    }
    try {
      await _notesCollection.doc(note.id).set(note.toJson());
    } catch (e) {
      throw Exception('Ошибка при создании заметки: $e');
    }
  }

  /// Обновить заметку
  Future<void> updateNote(Notes note) async {
    if (_currentUserId.isEmpty) return;
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
    if (_currentUserId.isEmpty) return;
    try {
      await _notesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Ошибка при удалении заметки: $e');
    }
  }

  /// Поиск заметок
  Future<List<Notes>> searchNotes(String query) async {
    if (_currentUserId.isEmpty) return [];
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
    if (_currentUserId.isEmpty) return;
    try {
      await _notesCollection.doc(noteId).update({'categoryId': newCategoryId});
    } catch (e) {
      throw Exception('Ошибка при обновлении категории: $e');
    }
  }

  /// Получить заметки по категории
  Future<List<Notes>> getNotesByCategoryId(String categoryId) async {
    if (_currentUserId.isEmpty) return [];
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
