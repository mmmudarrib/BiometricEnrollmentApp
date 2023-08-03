import 'package:flutter/material.dart';

class BiometricPreEnrollWidget extends StatelessWidget {
  final VoidCallback onStartEnrolling;
  const BiometricPreEnrollWidget({
    super.key,
    required this.onStartEnrolling,
  });

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
                    "Let's Enroll Biometrics for Jhon Doe",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Please click Enroll Biometrics Button to start the process\nYou will be asked to place your finger on the scanner three times",
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
                        onStartEnrolling();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: const Text('Start Enrolling'),
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
                    "assets/images/user_enter_biometrics_vector.png",
                    width: 100,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
