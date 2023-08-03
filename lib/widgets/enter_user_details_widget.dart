import 'package:flutter/material.dart';

class EnterUserDetailsWidget extends StatelessWidget {
  final VoidCallback nextPage;
  const EnterUserDetailsWidget({
    super.key,
    required this.nextPage,
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
                  const Text(
                    "Let's Verify the user details",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Please Enter the UserID below and click verify.",
                    style: TextStyle(fontSize: 16, wordSpacing: 4),
                  ),
                  Container(
                    height: 60.0,
                    width: 400,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Input user ID here",
                        fillColor: Colors.white70,
                      ),
                    ),
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
                      child: const Text('Verify'),
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
                    'assets/images/verify_user_vector.png',
                    width: 100,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
