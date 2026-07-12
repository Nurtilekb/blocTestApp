import '../models/card_manager.dart';
import '../models/user.dart';

class NotesRepository {
  final CardManager manager;

  NotesRepository(this.manager);

  List<Notes> getNotes() {
    return manager.getAllCards();
  }

  void createNote(Notes note) {
    manager.createCard(
      title: note.title,
      description: note.description,
      category: note.category,
      date: note.date,
    );
  }

  void deleteNote(String id) {
    manager.deleteCard(id);
  }

  void updateNote(Notes note) {
    manager.updateCard(note);
  }

  List<Notes> searchNotes(String query) {
    return manager.searchCards(query);
  }
}
