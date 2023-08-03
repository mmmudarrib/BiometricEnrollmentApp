import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zkfinger1/models/usb_device.dart';
import 'enums/page_step_enum.dart';
import 'pages/connect_device_page.dart';
import 'pages/enroll_biometrics_page.dart';
import 'pages/verify_user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//You can request multiple permissions at once.
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.storage,
    Permission.photos
  ].request();
  print("PERMISSIONS::${statuses[Permission.storage]}");
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
  static const platform = MethodChannel('abc');
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
                                color: Colors.grey,
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
                            const Text(
                              "Not Paired",
                              style: TextStyle(
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
          centerTitle: true,
          title: const Text(
            "Native Code Integration to Flutter ",
            style: TextStyle(color: Colors.orange),
          )),
      body: (pageStep == PageStep.CONNECT_DEVICE)
          ? ConnectDevicePage(
              paired: biometricDeviceModel != null,
              nextPage: () {},
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
                  : Container(),
    );
  }
}
