import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return (isEnrolling)
        ? BiometricPreEnrollWidget(
            onStartEnrolling: () {
              setState(() {
                isEnrolling = true;
              });
            },
          )
        : const BiometricEnrollingWidget();
  }
}
