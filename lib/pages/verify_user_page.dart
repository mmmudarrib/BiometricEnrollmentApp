import 'package:flutter/material.dart';
import 'package:zkfinger1/widgets/verified_user_details_widget.dart';

import '../widgets/enter_user_details_widget.dart';

class VerifyUserPage extends StatefulWidget {
  final VoidCallback onNextPage;
  const VerifyUserPage({super.key, required this.onNextPage});

  @override
  State<VerifyUserPage> createState() => _VerifyUserPageState();
}

class _VerifyUserPageState extends State<VerifyUserPage> {
  bool verified = false;
  @override
  Widget build(BuildContext context) {
    return (verified)
        ? VerifiedUserDetailsWidget(
            nextPage: (nextPage) {
              if (nextPage) {
                widget.onNextPage();
              } else {
                setState(() {
                  verified = false;
                });
              }
            },
          )
        : EnterUserDetailsWidget(
            nextPage: () {
              setState(() {
                verified = true;
              });
            },
          );
  }
}
