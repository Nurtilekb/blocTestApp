import 'package:bloctestapp/pages/create_note_page.dart';
import 'package:bloctestapp/widgets/cards_in_mainpages.dart';
import 'package:bloctestapp/widgets/category_list_cards.dart';
import 'package:flutter/material.dart';

class SeconOne extends StatefulWidget {
  const SeconOne({super.key});

  @override
  State<SeconOne> createState() => _SeconOneState();
}

class _SeconOneState extends State<SeconOne> {
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 15),
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          isSelected: true,
                          nameCategory: 'Работа',
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 12);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: ListView.separated(
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return CardsInPage();
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 25,
              right: 20,
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
