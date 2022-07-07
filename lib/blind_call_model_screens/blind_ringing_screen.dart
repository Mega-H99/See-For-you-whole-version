import 'package:flutter/material.dart';

class BlindCallingScreen extends StatelessWidget {
  const BlindCallingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Container(
        color: Colors.blueGrey.shade300,
          child: Column(
            children:  [
              const SizedBox(
                height: 40.0,
              ),
              CircleAvatar(
                radius: 60.0,
                child: Image.asset('assets/images/eye.png'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                'Calling',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 220.0,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'waiting for Volunteer to answer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
    ),
      );
  }
}
