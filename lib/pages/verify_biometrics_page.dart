import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../models/user.dart';

class VerifyBiometrics extends StatefulWidget {
  final VoidCallback startAgain;
  const VerifyBiometrics({super.key, required this.startAgain});

  @override
  State<VerifyBiometrics> createState() => _VerifyBiometricsState();
}

class _VerifyBiometricsState extends State<VerifyBiometrics> {
  static const platform = MethodChannel('abc');
  String? userUID = "";
  int status = 0;
  Future<void> setupCode() async {
    String uid = await platform.invokeMethod("getUserID");
    print("UserID$uid");
    setState(() {
      userUID = uid;
    });
    platform.setMethodCallHandler((call) async {
      print("Method Invoked::Name${call.method}::Arguments::${call.arguments}");
      if (call.method == "Identify") {
        if (call.arguments.toString() == userUID) {
          String feature = await platform.invokeMethod("getFeature");
          final User user = User(
            name: userUID ?? "",
            fingerprint: feature,
            isSync: false,
          );
          await makePostRequest(user);
          setState(() {
            status = 1;
            message = "User Enrolled Successfully";
          });
        } else {
          setState(() {
            message = "User Enrolling Failed Try again";
            status = -1;
          });
        }
      } else if (call.method == "IdentifyFail") {
        setState(() {
          message = "User Enrolling Failed Try again";
          status = -1;
        });
      }
    });
  }

  Future<void> makePostRequest(User user) async {
    const url = "http://172.20.18.35:8080/api/users";
    final dio = Dio();

    try {
      final response = await dio.post(url, data: user.toJson());
      print("Response: ${response.statusCode}");
      print("Response data: ${response.data}");
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    setupCode();
    super.initState();
  }

  String message = "Verify Biometrics For Jhon Doe";

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
                  Text(
                    "Let's Verify Biometrics for $userUID",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 16, wordSpacing: 4),
                  ),
                  Center(
                    child: SizedBox(
                        height: 150,
                        child: Image.asset("assets/images/fingerprint.png")),
                  ),
                  if (status == 1 || status == -1)
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
                          widget.startAgain();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent),
                        child: Text((status == -1)
                            ? 'Restart'
                            : (status == 1)
                                ? 'Enroll Next User'
                                : ""),
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
                    child: (status == 0)
                        ? Lottie.asset('assets/animations/verify_finger.json')
                        : (status == 1)
                            ? Lottie.asset('assets/animations/success.json')
                            : (status == -1)
                                ? Lottie.asset('assets/animations/failure.json')
                                : Lottie.asset(
                                    'assets/animations/verify_finger.json'))),
          ],
        ),
      ),
    );
  }
}
