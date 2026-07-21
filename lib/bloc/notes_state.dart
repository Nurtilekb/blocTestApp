part of 'notes_bloc.dart';

/// Состояния BLoC с поддержкой категорий из Firestore
/// Исправлено: убран хардкод категорий, используется CategoryModel
sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

final class NotesLoading extends NotesState {
  const NotesLoading();
}

class NotesLoaded extends NotesState {
  final List<Notes> notes;
  final List<CategoryModel> categories; // Исправлено: CategoryModel вместо List<String>

  const NotesLoaded({
    required this.notes,
    required this.categories,
  });

  @override
  List<Object?> get props => [notes, categories];
}

final class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}

final class CategoriesLoaded extends NotesState {
  final List<CategoryModel> categories;

  const CategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}
