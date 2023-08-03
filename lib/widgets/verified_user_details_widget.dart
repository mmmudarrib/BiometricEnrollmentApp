import 'package:flutter/material.dart';

class VerifiedUserDetailsWidget extends StatefulWidget {
  final Function(bool next) nextPage;
  const VerifiedUserDetailsWidget({super.key, required this.nextPage});

  @override
  State<VerifiedUserDetailsWidget> createState() =>
      _VerifiedUserDetailsWidgetState();
}

class _VerifiedUserDetailsWidgetState extends State<VerifiedUserDetailsWidget> {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome Jhon Doe",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "We are glad that you are using Mian Biometrics Module\nPlease press Proceed Next button when you are ready to start your Biometrics",
                    style: TextStyle(fontSize: 16, wordSpacing: 4),
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
                        widget.nextPage(true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: const Text('Proceed Next'),
                    ),
                  ),
                  Container(
                    height: 44.0,
                    width: 200,
                    color: Colors.grey,
                    child: ElevatedButton(
                      onPressed: () async {
                        widget.nextPage(false);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: const Text('I am not JhonDoe'),
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
                    'assets/images/welcome_user_vector.png',
                    width: 100,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
