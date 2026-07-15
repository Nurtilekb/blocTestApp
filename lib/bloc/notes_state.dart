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
  final String searchQuery;
  final List<String>
  allCategories; // 👈 ВСЕ категории (дефолтные + использованные)

  const NotesLoaded({
    required this.notes,
    this.searchQuery = '',
    this.allCategories = const [
      'Личное',
      'Работа',
      'Идеи',
      'Важное',
    ], // 👈 дефолтные
  });

  @override
  List<Object> get props => [notes, searchQuery, allCategories];
}

final class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object> get props => [message];
}
