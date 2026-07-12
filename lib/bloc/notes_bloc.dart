import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloctestapp/bloc/notes_repository.dart';
import 'package:bloctestapp/models/card_manager.dart';
import 'package:bloctestapp/models/user.dart';
import 'package:equatable/equatable.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository repository;
  NotesBloc(this.repository) : super(NotesLoading()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<DeleteNote>(_onDeleteNote);
    on<UpdateNote>(_onUpdateNote);
    on<SearchNotes>(_onSearchNotes);
  }
  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = repository.getNotes();
      emit(NotesLoaded(notes: notes)); // 👈 именованный параметр
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    repository.deleteNote(event.id);
    emit(NotesLoaded(notes: repository.getNotes())); // 👈 именованный параметр
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    repository.createNote(event.note);
    emit(NotesLoaded(notes: repository.getNotes())); // 👈 именованный параметр
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    repository.updateNote(event.note);
    emit(NotesLoaded(notes: repository.getNotes())); // 👈 именованный параметр
  }

  Future<void> _onSearchNotes(
    SearchNotes event,
    Emitter<NotesState> emit,
  ) async {
    final list = repository.searchNotes(event.query);
    emit(NotesLoaded(notes: list, searchQuery: event.query));
  }
}
