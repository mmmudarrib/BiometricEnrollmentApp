import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zkfinger1/models/usb_device.dart';
import 'package:zkfinger1/pages/verify_biometrics_page.dart';

import 'enums/page_step_enum.dart';
import 'pages/choice_page.dart';
import 'pages/connect_device_page.dart';
import 'pages/enroll_biometrics_page.dart';
import 'pages/verify_user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//You can request multiple permissions at once.

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  USBDeviceModel? biometricDeviceModel;
  bool paired = false;
  static const platform = MethodChannel('abc');
  Future<void> setupCode() async {
    platform.setMethodCallHandler((call) async {
      String res = await platform.invokeMethod("clear");
      print("Method Invoked::Name${call.method}::Arguments::${call.arguments}");
      if (call.method == "Done Registering") {
        String res = await platform.invokeMethod("startIdentify");
        print("startIdentify$res");
      }
    });
  }

  Future<void> listDevices() async {
    try {
      final List<Object?> result = await platform.invokeMethod('listDevices');
      for (var element in result) {
        USBDeviceModel deviceModel =
            USBDeviceModel.fromJson(jsonDecode(jsonEncode(element)));
        if (deviceModel.vid == 6997) {
          setState(() {
            biometricDeviceModel = deviceModel;
          });
        }
      }
    } on PlatformException catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
  }

  late PageStep pageStep;
  @override
  void initState() {
    pageStep = PageStep.CONNECT_DEVICE;
    setupCode();
    listDevices();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Row(
              children: [
                if (biometricDeviceModel == null)
                  const Text(
                    "No Device Connected",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: (paired) ? Colors.green : Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              "Device Name:${biometricDeviceModel?.productName ?? ""}",
                              style: const TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              (paired) ? "Connected" : "Not Paired",
                              style: const TextStyle(
                                  fontSize: 10.0, color: Colors.black),
                            )
                          ],
                        )
                      ],
                    ),
                  )
              ],
            ),
            const SizedBox(
              width: 50,
            ),
          ],
          leading: Image.asset(
            "assets/images/bbarray_logo.png",
            width: 150,
            height: 200,
          ),
          centerTitle: true,
          title: Image.asset(
            "assets/images/logo_italk.png",
            width: 150,
            height: 200,
          )),
      body: (pageStep == PageStep.CONNECT_DEVICE)
          ? ConnectDevicePage(
              paired: biometricDeviceModel != null,
              nextPage: () async {
                var res = await platform.invokeMethod('start');
                print(res);

                if (res == "connected" || res == "Device already connected!") {
                  setState(() {
                    pageStep = PageStep.CHOICE_PAGE;
                    paired = true;
                  });
                }
              },
            )
          : (pageStep == PageStep.CHOICE_PAGE)
              ? VerifyChoicePage(
                  onNextPage: (step) {
                    setState(() {
                      pageStep = step;
                    });
                  },
                )
              : (pageStep == PageStep.ENTER_USER)
                  ? VerifyUserPage(
                      onNextPage: () {
                        setState(() {
                          pageStep = PageStep.ENTER_BIOMETRICS;
                        });
                      },
                    )
                  : (pageStep == PageStep.ENTER_BIOMETRICS)
                      ? EnrollBiometricsPage(
                          onNextPage: () {
                            setState(() {
                              pageStep = PageStep.VERIFY_BIOMETRICS;
                            });
                          },
                        )
                      : (pageStep == PageStep.VERIFY_BIOMETRICS)
                          ? VerifyBiometrics(
                              startAgain: () async {
                                String res =
                                    await platform.invokeMethod("clear");
                                setState(() {
                                  pageStep = PageStep.CONNECT_DEVICE;
                                });
                              },
                            )
                          : Container(),
    );
  }
}
