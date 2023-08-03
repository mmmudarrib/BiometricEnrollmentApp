import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BiometricEnrollingWidget extends StatefulWidget {
  const BiometricEnrollingWidget({super.key});

  @override
  State<BiometricEnrollingWidget> createState() =>
      _BiometricEnrollingWidgetState();
}

class _BiometricEnrollingWidgetState extends State<BiometricEnrollingWidget> {
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
                    "Please Place your Finger on Scanner(1/3)",
                    style: TextStyle(fontSize: 16, wordSpacing: 4),
                  ),
                  Center(
                    child: SizedBox(
                        height: 150,
                        child: Image.asset("assets/images/fingerprint.png")),
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
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: const Text('Proceed Next'),
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
                    height: 300,
                    child: Lottie.asset(
                        'assets/animations/biometric_scanner_animation.json'))),
          ],
        ),
      ),
    );
  }
}
