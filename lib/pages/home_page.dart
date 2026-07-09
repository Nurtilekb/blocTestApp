import 'package:bloctestapp/pages/2_states_of_home_page/got_card.dart';
import 'package:bloctestapp/pages/search_page.dart';
import 'package:bloctestapp/pages/2_states_of_home_page/withOut_notes.dart';
import 'package:bloctestapp/services/%D1%81ardListScreen.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final hadItems = true;
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
              Text(
                widget.title,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight(700)),
              ),
              Spacer(),
              IconButton.filled(
                iconSize: 32,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.black12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CardListScreen()),
                  );
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
      body: hadItems ? SeconOne() : WithOutNotes(),
    );
  }
}
