part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final Notes note;

  const AddNote(this.note);
}

class DeleteNote extends NotesEvent {
  final String id;

  const DeleteNote(this.id);
}

class UpdateNoteCategory extends NotesEvent {
  final String noteId;
  final String newCategory;

  const UpdateNoteCategory({required this.noteId, required this.newCategory});

  @override
  List<Object> get props => [noteId, newCategory];
}

class SearchNotes extends NotesEvent {
  final String query;
  const SearchNotes({required this.query}); // только именованный параметр

  @override
  List<Object> get props => [query]; // строго List<Object>
}

class UpdateNote extends NotesEvent {
  final Notes note;

  const UpdateNote(this.note);
}
