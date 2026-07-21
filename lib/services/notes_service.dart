// services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notes_model.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _notesCollection => _firestore.collection('notes');

  // ========== ЗАМЕТКИ ==========
  Future<List<Notes>> getAllNotes() async {
    final snapshot = await _notesCollection.get();
    return snapshot.docs
        .map((doc) => Notes.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addNote(Notes note) async {
    await _notesCollection.doc(note.id).set(note.toJson());
  }

  Future<void> updateNote(Notes note) async {
    await _notesCollection
        .doc(note.id)
        .set(note.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }

  Future<List<Notes>> searchNotes(String query) async {
    final lowerQuery = query.toLowerCase();
    final snapshot = await _notesCollection.get();
    return snapshot.docs
        .map((doc) => Notes.fromJson(doc.data() as Map<String, dynamic>))
        .where(
          (note) =>
              note.title.toLowerCase().contains(lowerQuery) ||
              note.description.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  Future<void> updateNoteCategory(String noteId, int newCategoryId) async {
    await _notesCollection.doc(noteId).update({'category': newCategoryId});
  }

  Future<List<Notes>> getNotesByCategoryId(String categoryId) async {
    final snapshot = await _notesCollection
        .where('categoryId', isEqualTo: categoryId)
        .get();
    return snapshot.docs
        .map((doc) => Notes.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
