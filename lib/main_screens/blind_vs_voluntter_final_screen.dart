import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'call_screen_volunteer.dart';
import 'choose-part.dart';

class BlindVSVolunteerFinalScreen extends StatefulWidget {
  const BlindVSVolunteerFinalScreen({Key key}) : super(key: key);

  @override
  State<BlindVSVolunteerFinalScreen> createState() => _BlindVSVolunteerFinalScreenState();
}

class _BlindVSVolunteerFinalScreenState extends State<BlindVSVolunteerFinalScreen> {
  bool isBlind = false;

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initTts();
    speak("welcome to see for me "
        "For Visual aid tap once on the screen"
        "else if you are a volunteer long press on the screen");
    setState(() {});
  }

  initTts() async {
    await flutterTts.setLanguage("en-us");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.awaitSpeakCompletion(true);
  }

  speak(String wordsToSay) async {
    await flutterTts.speak(wordsToSay);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        isBlind = true;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChooseBlindModeScreen()),
        );
      },
      onLongPress: ()
      {
        isBlind = false;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CallScreenVolunteer()),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade300,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                width: double.infinity,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Image.asset(
                      "assets/images/blind-person.png",
                    height: 120.0,
                    width: 90.0,
                    ),
                    const Text(
                      'Blind',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1.0,
              color: Colors.white,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.purple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Image.asset(
                      "assets/images/volunteer.png",
                      height: 120.0,
                      width: 90.0,
                    ),
                   const Text(
                      'Volunteer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}