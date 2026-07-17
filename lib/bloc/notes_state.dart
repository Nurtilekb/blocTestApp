part of 'notes_bloc.dart';

sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

final class NotesLoading extends NotesState {
  const NotesLoading();
}

class NotesLoaded extends NotesState {
  final List<Notes> notes;
  final List<String> allCategories;

  const NotesLoaded({
    required this.notes,
    this.allCategories = const [
      'Личное',
      'Работа',
      'Идеи',
      'Важное',
    ],
  });

  @override
  List<Object> get props => [notes, allCategories];
}

class CategoriesLoaded extends NotesState {
  final List<CategoryModel> categories;

  const CategoriesLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

final class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object> get props => [message];
}
