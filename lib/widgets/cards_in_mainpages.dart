import 'package:bloctestapp/widgets/show_delete_diolog.dart';
import 'package:flutter/material.dart';

class CardsInPage extends StatefulWidget {
  const CardsInPage({super.key});

  @override
  State<CardsInPage> createState() => _CardsInPageState();
}

class _CardsInPageState extends State<CardsInPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {},
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => ShowDeleteDiolog(),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
          ),

          height: 180,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Созвон по релизу",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                maxLines: 3,
                "Обсудить блокеры, финальный QA и дату публикации в сторах.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.1,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    '5 июля',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight(600),
                      color: Colors.grey,
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 30,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.6, color: Colors.transparent),
                      color: const Color.fromARGB(115, 187, 222, 251),
                      borderRadius: BorderRadius.circular(25),
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
                    ),
                    child: Center(
                      child: Text(
                        'Работа',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 69, 100, 240),
                          fontWeight: FontWeight(500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
