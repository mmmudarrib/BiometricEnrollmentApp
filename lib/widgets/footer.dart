import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        children: [
          const Text("Powered By:"),
          Image.asset(
            "assets/images/bbarray_logo.png",
            height: 100,
          ),
        ],
      ),
    );
  }
}
