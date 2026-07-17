import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/bloc/repositories/notes_repository.dart';
import 'package:bloctestapp/models/category_model.dart';
import 'package:bloctestapp/models/note.dart';
import 'package:bloctestapp/pages/hompage/home_page.dart';
import 'package:bloctestapp/services/card_manager.dart';
import 'package:bloctestapp/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'theme/light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Firebase
  await Firebase.initializeApp();
  
  // Инициализация стандартных категорий в Firestore
  final firestoreService = FirestoreService();
  await firestoreService.initializeDefaultCategories();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => NotesRepository(CardManager()),
      child: BlocProvider(
        create: (context) =>
            NotesBloc(context.read<NotesRepository>())..add(LoadNotes()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: MyTheme().light(),
          home: const MyHomePage(),
        ),
      ),
    );
  }
}
