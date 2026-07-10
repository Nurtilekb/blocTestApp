import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/bloc/notes_repository.dart';
import 'package:bloctestapp/models/card_manager.dart';
import 'package:bloctestapp/models/user.dart';
import 'package:bloctestapp/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NotesAdapter()); // Регистрируем адаптер

  await Hive.openBox<Notes>('cardsBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => NotesRepository(CardManager()),
      child: BlocProvider(
        create: (context) =>
            NotesBloc(context.read<NotesRepository>())..add(LoadNotes()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFF007AFF),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            scaffoldBackgroundColor: const Color(0xFFF2F2F7),
            primaryColor: const Color(0xFF007AFF),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFFF2F2F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          home: RepositoryProvider(
            create: (context) => NotesRepository(CardManager()),
            child: const MyHomePage(title: 'Заметки'),
          ),
        ),
      ),
    );
  }
}
