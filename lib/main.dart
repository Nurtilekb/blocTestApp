import 'package:bloctestapp/bloc/auth/auth_bloc.dart';
import 'package:bloctestapp/bloc/auth/auth_state.dart';
import 'package:bloctestapp/bloc/notes/notes_bloc.dart';
import 'package:bloctestapp/bloc/repositories/notes_repository.dart';
import 'package:bloctestapp/firebase_options.dart';
import 'package:bloctestapp/pages/authentication/sign_in_page.dart';
import 'package:bloctestapp/pages/home_page/home_page.dart';
import 'package:bloctestapp/services/auth_service.dart';
import 'package:bloctestapp/services/category_service.dart';
import 'package:bloctestapp/services/notes_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme/light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authService = AuthService();

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => NotesRepository(NotesService(), CategoryService()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authService: authService)),
          BlocProvider(
            create: (context) =>
                NotesBloc(context.read<NotesRepository>())..add(LoadNotes()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: MyTheme().light(),
          home: const AuthGate(),
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF0066FF)),
            ),
          );
        }

        if (state is Authenticated) {
          return const MyHomePage();
        }

        return const SignInPage();
      },
    );
  }
}
