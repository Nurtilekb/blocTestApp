import 'package:bloctestapp/constants/app_constants.dart';
import 'package:bloctestapp/pages/create/create_note_page.dart';
import 'package:flutter/material.dart';

class WithoutNotes extends StatelessWidget {
  const WithoutNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.only(bottom: 25),
                    decoration: cardDecoration.copyWith(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    height: 100,
                    width: 100,
                    child: Image.asset('assets/icons/note.png', color: Colors.grey),
                  ),
                  const Text(
                    'Пока нет заметок',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: const Text(
                      textAlign: TextAlign.center,
                      'Нажмите <<+>> ,чтобы создать первую заметку и навести порядок в мыслях',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 25,
              right: 0,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateNotePage()),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Color(0xFF007AFF),
                  ),
                  height: 70,
                  width: 70,
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.white, size: 35),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
