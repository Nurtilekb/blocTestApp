import 'dart:async';

import 'package:bloctestapp/bloc/auth/auth_event.dart';
import 'package:bloctestapp/bloc/auth/auth_state.dart';
import 'package:bloctestapp/services/auth_service.dart';
import 'package:bloctestapp/services/category_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  late final StreamSubscription<User?> _userSubscription;

  AuthBloc({required AuthService authService})
    : _authService = authService,
      super(AuthInitial()) {
    _userSubscription = _authService.authStateChanges.listen((user) {
      add(AuthUserChanged(user));
    });

    on<SignInRequested>(_onSignIn);
    on<SignUpRequested>(_onSignUp);
    on<SignOutRequested>(_onSignOut);
    on<AuthUserChanged>(_onUserChanged);
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(Authenticated(event.user!));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await _authService.signIn(event.email, event.password);
      if (credential.user != null) {
        emit(Authenticated(credential.user!));
      }
    } catch (e) {
      emit(AuthError('Ошибка авторизации: ${e.toString()}'));
    }
  }

  Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await _authService.signUp(event.email, event.password);
      if (credential.user != null) {
        await CategoryService().initializeDefaultCategories();
        emit(Authenticated(credential.user!));
      }
    } catch (e) {
      emit(AuthError('Ошибка регистрации: ${e.toString()}'));
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authService.signOut();
    emit(Unauthenticated());
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
        return 'Неверный пароль';
      case 'invalid-credential': // ← добавь это
        return 'Неверный email или пароль';
      case 'email-already-in-use':
        return 'Email уже используется';
      case 'weak-password':
        return 'Слишком слабый пароль';
      case 'invalid-email':
        return 'Некорректный email';
      case 'user-disabled':
        return 'Аккаунт заблокирован';
      case 'too-many-requests':
        return 'Слишком много попыток. Попробуйте позже';
      case 'operation-not-allowed':
        return 'Email/пароль авторизация не включена в Firebase Console';
      default:
        return 'Ошибка авторизации: $code'; // ← покажи код для отладки
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
