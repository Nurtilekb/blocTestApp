import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloctestapp/models/card_manager.dart';
import 'package:bloctestapp/models/user.dart';
import 'package:equatable/equatable.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final CardManager manager;
  NotesBloc(this.manager) : super(NotesLoading()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<DeleteNote>(_onDeleteNote);
    on<UpdateNote>(_onUpdateNote);
    on<SearchNotes>(_onSearchNotes);
  }
  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());

    try {
      final notes = manager.getAllCards();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    manager.deleteCard(event.id);

    emit(NotesLoaded(manager.getAllCards()));
  }

  FutureOr<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    manager.createCard(
      title: event.note.title,
      description: event.note.description,
      category: event.note.category,
    );
    emit(NotesLoaded(manager.getAllCards()));
  }

  FutureOr<void> _onUpdateNote(
    UpdateNote event,
    Emitter<NotesState> emit,
  ) async {
    manager.updateCard(event.note);
    emit(NotesLoaded(manager.getAllCards()));
  }

  FutureOr<void> _onSearchNotes(
    SearchNotes event,
    Emitter<NotesState> emit,
  ) async {
    final List<Notes> list = manager.searchCards(event.query);
    emit(NotesLoaded(list));
  }
}
