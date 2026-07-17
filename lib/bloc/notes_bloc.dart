import 'dart:async';

import 'package:bloctestapp/bloc/repositories/notes_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloctestapp/models/note.dart';
import 'package:bloctestapp/models/category_model.dart';
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

    on<UpdateNoteCategory>(_onUpdateNoteCategory);
    on<LoadCategories>(_onLoadCategories);
    on<CreateCategory>(_onCreateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<UpdateCategory>(_onUpdateCategory);
  }
  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    if (state is! NotesLoaded) {
      emit(NotesLoading());
    }
    try {
      final notes = await repository.getNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    await repository.deleteNote(event.id);
    final notes = await repository.getNotes();
    emit(NotesLoaded(notes: notes));
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    await repository.createNote(event.note);
    final notes = await repository.getNotes();
    emit(NotesLoaded(notes: notes));
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    await repository.updateNote(event.note);
    final notes = await repository.getNotes();
    emit(NotesLoaded(notes: notes));
  }

  Future<void> _onUpdateNoteCategory(
    UpdateNoteCategory event,
    Emitter<NotesState> emit,
  ) async {
    final notes = await repository.getNotes();
    final index = notes.indexWhere((note) => note.id == event.noteId);

    if (index != -1) {
      notes[index].category = event.newCategory;
      repository.updateNote(notes[index]);
      _usedCategories.add(event.newCategory);
    }

    emit(
      NotesLoaded(
        notes: await repository.getNotes(),
        allCategories: _usedCategories.toList(),
      ),
    );
  }

  Future<void> _onCreateCategory(
    CreateCategory event,
    Emitter<NotesState> emit,
  ) async {
    await repository.createCategory(event.name);
    final categories = await repository.getCategories();
    emit(CategoriesLoaded(categories: categories));
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<NotesState> emit,
  ) async {
    await repository.deleteCategory(event.id);
    final categories = await repository.getCategories();
    emit(CategoriesLoaded(categories: categories));
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<NotesState> emit,
  ) async {
    await repository.updateCategory(event.id, event.newName);
    final categories = await repository.getCategories();
    emit(CategoriesLoaded(categories: categories));
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<NotesState> emit,
  ) async {
    final categories = await repository.getCategories();
    emit(CategoriesLoaded(categories: categories));
  }
}
