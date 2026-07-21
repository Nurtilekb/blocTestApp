part of 'notes_bloc.dart';

/// События BLoC с исправленными типами
/// Исправлено: categoryId теперь String (вместо int) для согласованности
sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesEvent {}

class LoadNotesByCategoryId extends NotesEvent {
  final String categoryId;

  const LoadNotesByCategoryId(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class AddNote extends NotesEvent {
  final Notes note;

  const AddNote(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NotesEvent {
  final String id;

  const DeleteNote(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateNoteCategory extends NotesEvent {
  final String noteId;
  final String newCategoryId; // Исправлено: String вместо newCategory

  const UpdateNoteCategory({required this.noteId, required this.newCategoryId});

  @override
  List<Object?> get props => [noteId, newCategoryId];
}

class UpdateNote extends NotesEvent {
  final Notes note;

  const UpdateNote(this.note);

  @override
  List<Object?> get props => [note];
}

class LoadCategories extends NotesEvent {}

class CreateCategory extends NotesEvent {
  final String name;
  final String? id;

  const CreateCategory(this.name, {this.id});

  @override
  List<Object?> get props => [name, id];
}

class DeleteCategory extends NotesEvent {
  final String id;

  const DeleteCategory(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateCategory extends NotesEvent {
  final String id;
  final String newName;

  const UpdateCategory({required this.id, required this.newName});

  @override
  List<Object?> get props => [id, newName];
}
