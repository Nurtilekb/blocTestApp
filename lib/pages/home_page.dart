import 'package:bloctestapp/widgets/app_input_widget.dart';
import 'package:bloctestapp/widgets/cards_in_mainpages.dart';
import 'package:bloctestapp/widgets/show_diolog.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight(700)),
              ),
              Spacer(),
              IconButton.filled(
                iconSize: 30,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.black12),
                ),
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0),
          child: Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                CardsInPage(),
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
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          showDialog(context: context, builder: (context) => Showdiolog());
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          ),
          height: 70,
          width: 70,
          child: Center(child: Icon(Icons.add, color: Colors.white, size: 35)),
        ),
      ),
    );
  }
}
