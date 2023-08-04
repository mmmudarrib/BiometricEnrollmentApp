import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class BiometricEnrollingWidget extends StatefulWidget {
  final VoidCallback onNextPage;
  const BiometricEnrollingWidget({super.key, required this.onNextPage});

  @override
  State<BiometricEnrollingWidget> createState() =>
      _BiometricEnrollingWidgetState();
}

class _BiometricEnrollingWidgetState extends State<BiometricEnrollingWidget> {
  @override
  void initState() {
    setupCode();
    super.initState();
  }

  String enrollCount = "Place the Finger on Scanner 3 times";
  static const platform = MethodChannel('abc');
  Future<void> setupCode() async {
    platform.setMethodCallHandler((call) async {
      print("Method Invoked::Name${call.method}::Arguments::${call.arguments}");
      if (call.method == "Done Registering") {
        setState(() {
          enrollCount = "Registered Successfully";
        });
        await platform.invokeMethod("startIdentify");
        widget.onNextPage();
      } else if (call.method == "registering") {
        setState(() {
          enrollCount = call.arguments.toString();
        });
      }
    });
  }

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
                  Text(
                    enrollCount,
                    style: const TextStyle(fontSize: 16, wordSpacing: 4),
                  ),
                  Center(
                    child: SizedBox(
                        height: 150,
                        child: Image.asset("assets/images/fingerprint.png")),
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
