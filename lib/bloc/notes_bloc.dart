import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloctestapp/bloc/repositories/notes_repository.dart';
import 'package:bloctestapp/models/notes_model.dart';
import 'package:bloctestapp/models/category_model.dart';
import 'package:equatable/equatable.dart';

part 'notes_event.dart';
part 'notes_state.dart';

/// BLoC для управления заметками и категориями
/// Исправлено:
/// - Добавлена обработка ошибок во все handler'ы
/// - Убран хардкод категорий (_usedCategories)
/// - Убрана гонка состояний при создании категории
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository repository;

  NotesBloc(this.repository) : super(const NotesLoading()) {
    on<LoadNotes>(_onLoadNotes);
    on<LoadNotesByCategoryId>(_onLoadNotesByCategoryId);
    on<AddNote>(_onAddNote);
    on<DeleteNote>(_onDeleteNote);
    on<UpdateNote>(_onUpdateNote);
    on<UpdateNoteCategory>(_onUpdateNoteCategory);
    on<LoadCategories>(_onLoadCategories);
    on<CreateCategory>(_onCreateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<UpdateCategory>(_onUpdateCategory);
  }

  Future<void> _onLoadNotes(
    LoadNotes event,
    Emitter<NotesState> emit,
  ) async {
    emit(const NotesLoading());
    try {
      final notes = await repository.getNotes();
      final categories = await repository.getCategories();
      emit(NotesLoaded(notes: notes, categories: categories));
    } catch (e) {
      emit(NotesError('Ошибка загрузки заметок: ${e.toString()}'));
    }
  }

  Future<void> _onLoadNotesByCategoryId(
    LoadNotesByCategoryId event,
    Emitter<NotesState> emit,
  ) async {
    emit(const NotesLoading());
    try {
      final notes = await repository.getNotesByCategoryId(event.categoryId);
      final categories = await repository.getCategories();
      emit(NotesLoaded(notes: notes, categories: categories));
    } catch (e) {
      emit(NotesError('Ошибка фильтрации по категории: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteNote(
    DeleteNote event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await repository.deleteNote(event.id);
      final notes = await repository.getNotes();
      final categories = await repository.getCategories();
      emit(NotesLoaded(notes: notes, categories: categories));
    } catch (e) {
      emit(NotesError('Ошибка удаления заметки: ${e.toString()}'));
    }
  }

  Future<void> _onAddNote(
    AddNote event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await repository.createNote(event.note);
      final notes = await repository.getNotes();
      final categories = await repository.getCategories();
      emit(NotesLoaded(notes: notes, categories: categories));
    } catch (e) {
      emit(NotesError('Ошибка создания заметки: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateNote(
    UpdateNote event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await repository.updateNote(event.note);
      final notes = await repository.getNotes();
      final categories = await repository.getCategories();
      emit(NotesLoaded(notes: notes, categories: categories));
    } catch (e) {
      emit(NotesError('Ошибка обновления заметки: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateNoteCategory(
    UpdateNoteCategory event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await repository.updateNoteCategory(event.noteId, event.newCategoryId);
      final notes = await repository.getNotes();
      final categories = await repository.getCategories();
      emit(NotesLoaded(notes: notes, categories: categories));
    } catch (e) {
      emit(NotesError('Ошибка обновления категории: ${e.toString()}'));
    }
  }

  Future<void> _onCreateCategory(
    CreateCategory event,
    Emitter<NotesState> emit,
  ) async {
    emit(const NotesLoading());
    try {
      await repository.createCategory(event.name, id: event.id);
      final categories = await repository.getCategories();
      final notes = await repository.getNotes();
      emit(NotesLoaded(notes: notes, categories: categories));
    } catch (e) {
      emit(NotesError('Ошибка создания категории: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await repository.deleteCategory(event.id);
      final categories = await repository.getCategories();
      final notes = await repository.getNotes();
      emit(NotesLoaded(notes: notes, categories: categories));
    } catch (e) {
      emit(NotesError('Ошибка удаления категории: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await repository.updateCategory(event.id, event.newName);
      final categories = await repository.getCategories();
      final notes = await repository.getNotes();
      emit(NotesLoaded(notes: notes, categories: categories));
    } catch (e) {
      emit(NotesError('Ошибка обновления категории: ${e.toString()}'));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<NotesState> emit,
  ) async {
    try {
      final categories = await repository.getCategories();
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      emit(NotesError('Ошибка загрузки категорий: ${e.toString()}'));
    }
  }
}
