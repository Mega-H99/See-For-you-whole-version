
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:see_for_you_alpha_version/hardware-bluetooth-part/bluetooth_screen.dart';
import 'package:see_for_you_alpha_version/main_screens/call_blind_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../recognition_detection_screens/pages_of_recognition/rushdi_stt_screen.dart';
import '../recognition_detection_screens/utils/tts.dart';

class ChooseBlindModeScreen extends StatefulWidget {
   const ChooseBlindModeScreen({Key key}) : super(key: key);

  @override
  State<ChooseBlindModeScreen> createState() => _ChooseBlindModeScreenState();
}

class _ChooseBlindModeScreenState extends State<ChooseBlindModeScreen> {
  bool isBlind = false;
  TTS tts;


  @override
  void initState() {
    super.initState();
    initializeTTS();
    tts.speak("Choose your mode.  "
          "Tap for app assistant mode.  "
          "Double tap for volunteer assistant mode.  "
          "Long press for walking mode.  "
          "Horizontal drag for google maps track.  "
    );

  }

  void initializeTTS() {
    tts = TTS();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RushdiSttScreen()),
        );

      },
      onDoubleTap: ()
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CallScreenBlind()),
        );

      },
      onLongPress: ()
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BluetoothScreen()),
        );
      },
      onVerticalDragEnd: (details)
      {
        MapUtils.openMap(30.033333, 31.233334);
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade300,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Image.asset(
                          "assets/images/chatbot.png",
                          height: 80.0,
                          width: 60.0,
                        ),
                        const Text(
                          'App Assistant',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 1.0,
                ),
                Expanded(
                  child: Container(
                    color: Colors.amber,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Image.asset(
                          "assets/images/video-call.png",
                          height: 80.0,
                          width: 60.0,
                        ),
                        const Text(
                          'volunteer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
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
            const SizedBox(
              height: 1.0,
            ),
            Expanded(
              child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blueGrey.shade300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Image.asset(
                          "assets/images/walking.png",
                          height: 80.0,
                          width: 60.0,
                        ),
                        const Text(
                          'walk mode',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 1.0,
                ),
                Expanded(
                  child: Container(
                    color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Image.asset(
                          "assets/images/map.png",
                          height: 80.0,
                          width: 60.0,
                        ),
                        const Text(
                          'Navigation mode',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
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
          ],
        ),
      ),
    );
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(
      double lat,
      double lng,
      ) async{
    String googleUrl =
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng";

    if(await canLaunch(googleUrl)){
      await launch(googleUrl);
    }
    else{
      throw "could not open the maps.";
    }

  }
}
