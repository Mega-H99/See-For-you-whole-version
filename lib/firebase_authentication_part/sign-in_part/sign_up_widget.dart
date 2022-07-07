import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'google_sign_in_provider.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  bool? isBlind;
  FlutterTts flutterTts = FlutterTts();

  void _initTts() async {
    await flutterTts.setLanguage("en-us");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.05);
    await flutterTts.awaitSpeakCompletion(true);
  }

  speak(String wordsToSay) async {
    await flutterTts.speak(wordsToSay);
    setState(() {});
  }


  @override
  void initState() {
    _initTts();
    super.initState();
    speak('Welcome to See for you'
        'Please let someone assist you with your'
        'first time to sign up to our app'
        'please sign with your google account'
    );
    // if(_speechToText.isListening){
    //   speak('you said $_lastWords');
    //   if(_lastWords.contains('I agree')){
    //     speak('Then lets begin signing you up'
    //           'For the assistant just sign up using the google account '
    //           'after that the app will be logged in always '
    //           'and the client can use it freely thank you');
    //   }
    // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade700,
        body: Container(
          padding: const EdgeInsets.all(16.0,),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('See For Me',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10.0,),
              const Text('Welcome Back :',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40.0,),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey.shade600,
                  onPrimary: Colors.black,
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ),
                ),
                onPressed: (){
                  final provider = Provider.of<GoogleSignInProvider>(context,listen:false);
                  provider.googleLogin(isBlind!);
                },
                icon: const Icon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
                label: const Text(
                  'Sign Up with Google',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height:16.0,),
              ElevatedButton(onPressed: (){isBlind=true;}, child: const Text('Blind')),
              ElevatedButton(onPressed: (){isBlind=false;}, child: const Text('Volunteer')),
            ],
          ),
        ),
      );
  }
}
