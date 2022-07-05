import 'package:flutter/material.dart';

class BlindCallingScreen extends StatelessWidget {
  const BlindCallingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
      color: Colors.blueGrey.shade300,
        child: Column(
          children:  [
            const SizedBox(
              height: 300.0,
            ),
            CircleAvatar(
              child: Image.asset('assets/images/eye.png'),
            ),
            const Text(
              'Calling',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 300.0,
            ),
            const Text(
              'waiting for Volunteer to answer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
    );
  }
}
