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

class SearchNotes extends NotesEvent {
  final String query;

  const SearchNotes(this.query);
}

class UpdateNote extends NotesEvent {
  final Notes note;

  const UpdateNote(this.note);
}
