import 'package:flutter/material.dart';

import '../enums/page_step_enum.dart';

class VerifyChoicePage extends StatefulWidget {
  final Function(PageStep step) onNextPage;
  const VerifyChoicePage({super.key, required this.onNextPage});

  @override
  State<VerifyChoicePage> createState() => _VerifyChoicePageState();
}

class _VerifyChoicePageState extends State<VerifyChoicePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Choose the right option",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 44.0,
                    width: 200,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 2, 173, 102),
                      Colors.blue
                    ])),
                    child: ElevatedButton(
                      onPressed: () async {
                        widget.onNextPage(PageStep.ENTER_USER);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: const Text(
                        'Enroll New User',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    height: 44.0,
                    width: 200,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 2, 173, 102),
                      Colors.blue
                    ])),
                    child: ElevatedButton(
                      onPressed: () async {
                        widget.onNextPage(PageStep.VERIFY_OLD_USER);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: const Text(
                        'Verify Old User',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 2,
                child: SizedBox(
                  width: 100,
                  child: Image.asset(
                    'assets/images/choice_vector.jpg',
                    width: 100,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
