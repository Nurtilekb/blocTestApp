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

class UpdateNote extends NotesEvent {
  final Notes note;

  const UpdateNote(this.note);
}

class LoadCategories extends NotesEvent {}

class CreateCategory extends NotesEvent {
  final String name;

  const CreateCategory(this.name);

  @override
  List<Object> get props => [name];
}

class DeleteCategory extends NotesEvent {
  final int id;

  const DeleteCategory(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateCategory extends NotesEvent {
  final int id;
  final String newName;

  const UpdateCategory({required this.id, required this.newName});

  @override
  List<Object> get props => [id, newName];
}
