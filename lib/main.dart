import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/bloc/repositories/notes_repository.dart';
import 'package:bloctestapp/models/category_model.dart';
import 'package:bloctestapp/services/card_manager.dart';
import 'package:bloctestapp/models/note.dart';
import 'package:bloctestapp/pages/hompage/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'theme/light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NotesAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  await Hive.openBox<Notes>('notesBox');
  final categoriesBox = await Hive.openBox<CategoryModel>('categoriesBox');

  if (categoriesBox.isEmpty) {
    final defaults = [
      CategoryModel(id: 0, name: 'Личное'),
      CategoryModel(id: 1, name: 'Работа'),
      CategoryModel(id: 2, name: 'Идеи'),
      CategoryModel(id: 3, name: 'Важное'),
    ];
    for (final cat in defaults) {
      await categoriesBox.put(cat.id, cat);
    }
  }

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
          theme: MyTheme().light(),
          home: RepositoryProvider(
            create: (context) => NotesRepository(CardManager()),
            child: const MyHomePage(),
          ),
        ),
      ),
    );
  }
}
