import 'dart:async';

import 'package:bloctestapp/bloc/repositories/notes_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloctestapp/models/note.dart';
import 'package:equatable/equatable.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository repository;
  final Set<String> _usedCategories = {'Личное', 'Работа', 'Идеи', 'Важное'};
  NotesBloc(this.repository) : super(NotesLoading()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<DeleteNote>(_onDeleteNote);
    on<UpdateNote>(_onUpdateNote);
    on<SearchNotes>(_onSearchNotes);
    on<UpdateNoteCategory>(_onUpdateNoteCategory);
  }
  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await repository.getNotes();
      emit(NotesLoaded(notes: notes)); // 👈 именованный параметр
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    await repository.deleteNote(event.id);
    final notes = await repository.getNotes();
    emit(NotesLoaded(notes: notes)); // 👈 именованный параметр
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    await repository.createNote(event.note);
    final notes = await repository.getNotes();
    emit(NotesLoaded(notes: notes)); // 👈 именованный параметр
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    await repository.updateNote(event.note);
    final notes = await repository.getNotes();
    emit(NotesLoaded(notes: notes)); // 👈 именованный параметр
  }

  Future<void> _onSearchNotes(
    SearchNotes event,
    Emitter<NotesState> emit,
  ) async {
    final list = await repository.searchNotes(event.query);
    emit(NotesLoaded(notes: list, searchQuery: event.query));
  }

  Future<void> _onUpdateNoteCategory(
    UpdateNoteCategory event,
    Emitter<NotesState> emit,
  ) async {
    final notes = await repository.getNotes();
    final index = notes.indexWhere((note) => note.id == event.noteId);

    if (index != -1) {
      notes[index].category = event.newCategory;
      await repository.updateNote(notes[index]);
      _usedCategories.add(event.newCategory); // 👈 запоминаем новую категорию
    }

    emit(
      NotesLoaded(
        notes: await repository.getNotes(),
        allCategories: _usedCategories.toList(), // 👈 все категории
      ),
    );
  }
}
