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

  late bool isBlind;

  final SpeechToText _speechToText = SpeechToText();
  late bool _speechEnabled ;
  String _lastWords = '';
  FlutterTts flutterTts = FlutterTts();

  void _initTts() async {
    await flutterTts.setLanguage("en-us");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(1.0);
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
    setState(() {});
  }


  @override
  void initState() {
    // TODO: implement initState
    _initSpeech();
    _initTts();
    super.initState();
    speak('Welcome to See for you'
        'Please let someone assist you with your'
        'first time to sign up to our app'
        'please sign with your google account'
        'if you are okay with this yes I agree '
        'if you want us to repeat to you say repeat '
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
    return //GestureDetector(
      //onTap: _speechToText.isNotListening ? _startListening : _stopListening,
      //child:
      Scaffold(
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
              const Text('Welcome Back :)',
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
                  provider.googleLogin(isBlind);
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
        //),
      );
  }
}
