import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ConnectDevicePage extends StatelessWidget {
  final VoidCallback nextPage;
  final bool paired;
  const ConnectDevicePage({
    super.key,
    required this.nextPage,
    required this.paired,
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
                  DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    child: AnimatedTextKit(
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TypewriterAnimatedText(
                            'Welcome to Biometric Enrollment App'),
                      ],
                    ),
                  ),
                  const Text(
                    "Lets get you guys on boarded.\nPlease connect the device to the system \nPress the button below to start the on boarding process",
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
                        nextPage();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: Text(
                          paired ? 'Connect the Device' : "Pair the Device"),
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
                    'assets/images/connect_device_vector.png',
                    width: 100,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
