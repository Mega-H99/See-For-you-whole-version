import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:see_for_you_alpha_version/blind_call_model_screens/blind_ringing_screen.dart';
import 'package:see_for_you_alpha_version/main_screens/blind_vs_volunteer_screen.dart';
import 'package:see_for_you_alpha_version/main_screens/blind_vs_volunteer_screen_with_voice.dart';
import 'package:see_for_you_alpha_version/main_screens/blind_vs_volunteer_with_sign_in_screen.dart';
import 'package:see_for_you_alpha_version/main_screens/call_blind_screen.dart';
import 'package:see_for_you_alpha_version/main_screens/call_screen_volunteer.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/banknotes-recognition.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/search-for-object.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/stt_screen.dart';

import 'blind_call_model_screens/blind_entering_video_call_screen.dart';
import 'main_screens/blind_vs_voluntter_final_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
      const BlindVSVolunteerFinalScreen(),
      //const BlindVSVolunteerScreenWithVoice(),
    );
  }
}




