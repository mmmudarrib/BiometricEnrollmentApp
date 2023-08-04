import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/biometric_enrolling_widget.dart';
import '../widgets/biometric_preenroll_widget.dart';

class EnrollBiometricsPage extends StatefulWidget {
  final VoidCallback onNextPage;
  const EnrollBiometricsPage({super.key, required this.onNextPage});

  @override
  State<EnrollBiometricsPage> createState() => _EnrollBiometricsPageState();
}

class _EnrollBiometricsPageState extends State<EnrollBiometricsPage> {
  bool isEnrolling = false;
  static const platform = MethodChannel('abc');

  @override
  Widget build(BuildContext context) {
    return (!isEnrolling)
        ? BiometricPreEnrollWidget(
            onStartEnrolling: () async {
              var res = await platform.invokeMethod("startRegister");
              print("startRegister$res");
              setState(() {
                isEnrolling = true;
              });
            },
          )
        : BiometricEnrollingWidget(
            onNextPage: widget.onNextPage,
          );
  }
}
