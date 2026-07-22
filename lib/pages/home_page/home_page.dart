import 'package:bloctestapp/bloc/auth/auth_bloc.dart';
import 'package:bloctestapp/bloc/auth/auth_event.dart';
import 'package:bloctestapp/bloc/notes/notes_bloc.dart';
import 'package:bloctestapp/pages/home_page/with_notes.dart';
import 'package:bloctestapp/pages/home_page/without_notes.dart';
import 'package:bloctestapp/pages/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text(
                'Заметки',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton.filled(
                iconSize: 25,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black12),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                ),
                icon: const Icon(Icons.search),
              ),
              SizedBox(width: 6),
              IconButton.filled(
                iconSize: 25,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black12),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                          'Do u realy want to sign out?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight(600),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              elevation: 5,

                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No'),
                          ),
                          SizedBox(width: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              elevation: 5,

                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(SignOutRequested());
                              Navigator.pop(context);
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.logout, size: 20),
              ),
            ],
          ),
        ),
      ),
      body: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {},
        buildWhen: (context, state) {
          if (state is NotesLoading ||
              state is NotesLoaded ||
              state is NotesError) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotesError) {
            return Center(child: Text(state.message));
          }

          if (state is NotesLoaded) {
            return state.notes.isEmpty
                ? const WithoutNotes()
                : const WithNotes();
          }

          return const SizedBox();
        },
      ),
    );
  }
}
