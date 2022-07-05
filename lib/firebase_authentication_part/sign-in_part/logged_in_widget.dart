import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:see_for_you_alpha_version/firebase_authentication_part/models/user_data.dart';
import 'package:see_for_you_alpha_version/firebase_authentication_part/sign-in_part/google_sign_in_provider.dart';
import 'package:see_for_you_alpha_version/main_screens/call_screen_volunteer.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/stt_screen.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';



class LoggedInWidget extends StatefulWidget {
  const LoggedInWidget({Key? key}) : super(key: key);

  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  final User user = FirebaseAuth.instance.currentUser!;
  UserData? userData;

  // late DocumentSnapshot<Map<String,dynamic>> snap;
  // 1 'displayName': displayName, Done
  // 2 'uid': uid, Done
  // 3 'avatarURL': avatarURL, Done
  // 4 'email':email, Done
  // 5 'phoneNumber': phoneNumber, Done
  // 6 'isBlind': isBlind, Done

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  FlutterTts flutterTts = FlutterTts();


  void _initTts() async {
    await flutterTts.setLanguage("en-us");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.awaitSpeakCompletion(true);
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult, localeId: "en_US");

    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  speak(String wordsToSay) async {
    await flutterTts.speak(wordsToSay);
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (_lastWords.contains('ahmed')) {
        Future.delayed(const Duration(seconds: 2), () {
          speak('hello ahmed');
        });
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    _initSpeech();
    _initTts();
    _getSnap();
    super.initState();
  }
  void _getSnap  () async{
    Stream<DocumentSnapshot<Map<String, dynamic>>>  snap =
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .snapshots() ;
    snap.forEach((element) {
      setState(() {
        userData = UserData.fromMap(element.data()!);

      });
      print(userData);
    });

  }

  @override
  Widget build(BuildContext context) {
    //FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots(),
    //FirebaseFirestore.instance
    //             .collection('Users')
    //             .where('uid',isEqualTo: user.uid)
    //              .snapshots(),
    // if (snap.hasError)
    // {
    //   return Text('error:${snap.error}');
    // }
    if(userData!.isBlind!) {
      speak('Hello ${userData!.displayName} you are logged in'
          'Here is your account data displayed on the screen '
          'you know that from your name the current account being used'
          'but if you want to further check for the rest of the information'
          'you can take a screen shot of this data and send it to anyone or '
          'you can get assist from anyone that surrounds you '
          'these data contains your picture your email your name and '
          'your phone number'
          'Further more to use the app and its features long press on the screen'
          'to deal with the voice assistant that helps you with your daily tasks');

      return GestureDetector(
        onTap: (){
        if(userData!.isBlind!) {
          speak('Hello ${userData!.displayName} you are logged in'
              'Here is your account data displayed on the screen '
              'you know that from your name the current account being used'
              'but if you want to further check for the rest of the information'
              'you can take a screen shot of this data and send it to anyone or '
              'you can get assist from anyone that surrounds you '
              'these data contains your picture your email your name and '
              'your phone number'
              'Further more to use the app and its features long press on the screen'
              'to deal with the voice assistant that helps you with your daily tasks');
        }
        },
        onLongPress: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>const SttScreen(),
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: const Text('Logged In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  final provider = Provider.of<GoogleSignInProvider>(
                      context, listen: false);
                  provider.logout();
                },
              ),
            ],

          ),
          body: Column(
            children: [
              Container(
                alignment: Alignment.center,
                color: Colors.blueGrey.shade900,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor:
                      userData!.isBlind! ? Colors.blue : Colors.purple,
                      child: Text(
                        userData!.isBlind! ? 'Blind' : 'volunteer',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.white,
                        ),

                      ),

                    ),
                    const SizedBox(height: 32.0,),
                    Text(
                      userData!.displayName != null ?
                      'Welcome ' + userData!.displayName! :
                      'Name is not contained',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32.0,),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          userData!.avatarURL != null ?
                          userData!.avatarURL! :
                          'https://www.elbalad.news/UploadCache/libfiles/904/7/600x338o/303.jpg'

                      ),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      userData!.phoneNumber != null ?
                      'phoneNumber: ' + userData!.phoneNumber! :
                      'phone number is not contained',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      'Email: ' + userData!.email!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 32.0,),
                    Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.blueGrey.shade700,
                      child: Row(
                        children: const [
                          Icon(
                            FontAwesomeIcons.eye,
                            color: Colors.white,
                          ),
                          Text(
                            'Start VideoCall',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
    else{
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text('Logged In',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                final provider = Provider.of<GoogleSignInProvider>(
                    context, listen: false);
                provider.logout();
              },
            ),
          ],

        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.center,
              color: Colors.blueGrey.shade900,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor:
                    userData!.isBlind! ? Colors.blue : Colors.purple,
                    child: Text(
                      userData!.isBlind! ? 'Blind' : 'volunteer',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.white,
                      ),

                    ),

                  ),
                  const SizedBox(height: 32.0,),
                  Text(
                    userData!.displayName != null ?
                    'Welcome ' + userData!.displayName! :
                    'Name is not contained',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32.0,),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        userData!.avatarURL != null ?
                        userData!.avatarURL! :
                        'https://www.elbalad.news/UploadCache/libfiles/904/7/600x338o/303.jpg'

                    ),
                  ),
                  const SizedBox(height: 8,),
                  Text(
                    userData!.phoneNumber != null ?
                    'phoneNumber: ' + userData!.phoneNumber! :
                    'phone number is not contained',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8,),
                  Text(
                    'Email: ' + userData!.email!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 32.0,),
                  ElevatedButton.icon(
                    icon: const Icon(
                      FontAwesomeIcons.video,
                      color: Colors.red,
                    ),
                    label: const Text(
                      'Start VideoCall',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey.shade700,
                      onPrimary: Colors.black,
                      minimumSize: const Size(
                        double.infinity,
                        50,
                      ),),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CallScreenVolunteer(),
                        ),
                      );
                    },

                  ),

                ],

              ),
            ),

          ],

        ),
      );
    }
  }


}
