import 'package:bloctestapp/pages/create/create_note_page.dart';
import 'package:flutter/material.dart';

class WithOutNotes extends StatelessWidget {
  const WithOutNotes({super.key});

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
                    padding: EdgeInsets.all(30),
                    margin: EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 2),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    height: 100,
                    width: 100,
                    child: Image.asset(
                      'assets/icons/note.png',
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Пока нет заметок',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight(700)),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      textAlign: TextAlign.center,
                      'Нажмите <<+>> ,чтобы создать первую заметку и навести порядок в мыслях',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight(400),
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
                onTap: () {
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => Showdiolog(),
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateNotePage()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Theme.of(
                      context,
                    ).floatingActionButtonTheme.backgroundColor,
                  ),
                  height: 70,
                  width: 70,
                  child: Center(
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
