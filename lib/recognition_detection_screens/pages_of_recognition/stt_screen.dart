import 'package:flutter/material.dart';
import 'package:see_for_you_alpha_version/main_screens/call_blind_screen.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/banknotes-recognition.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/cloth-detection.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/color-detection.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/face-recognition.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/text-read.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SttScreen extends StatefulWidget {
  const SttScreen({Key? key,}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SttScreen> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  FlutterTts flutterTts = FlutterTts();
  bool tutorialsNeeded = true;


  @override
  void initState() {
    super.initState();
    _initSpeech();
    initTts();

    Future.delayed(const Duration(seconds: 5), () {
      speak("welcome to blind assistant");
      setState(() {});
    });
      if(tutorialsNeeded) {
        speak('Welcome again'
            'We are happy to help you with your daily activities'
            'for that let us tell you our various features that you can use'
            'and how to use it'
            'for that we will tell you the steps of how to use every feature'
            'First things first'
            'The features that you can use are'
            'one search for object mode'
            'which tells you what object is in front of your mobile camera'
            'two video call assistant mode'
            'which calls a volunteer person and shares your mobile camera'
            'with this person to help you in a certain task'
            'three read text mode'
            'which reads any writing in front of your mobile camera'
            'four cloth mode'
            'tells you the clothes which is in front of your mobile camera'
            'fifth face recognize mode'
            'tells you who is the person in front of you by taking a picture of him'
            'sixth which color mode'
            'tells you the color in front of your mobile camera'
            'seventh money mode'
            'tells you how much money is in front of your mobile camera'
            'you can also use three more voice commands which are'
            'voice command one  tell me the features'
            'voice command two explain feature followed by the feature name'
            'voice command three which turns on or off the full explanation journey'
            'here you go know you can use the app'
            'Tap on the screen to choose one of our features'
            'just tap and say open followed by the name of the feature and tap again'
            'Then we will open that feature for you and continue the journey'
            'Lets try it now for example tap and say open video call assistant mode'
        );
      }

      else if (!tutorialsNeeded)
      {
        speak('Welcome again');
      }
      Future.delayed(const Duration(seconds: 50),()
      {
        _speechToText.isNotListening ? _startListening : _stopListening ;
        if(_speechToText.isListening) {
          speak('you said $_lastWords');
        }
      });

      if(_lastWords.contains('open search for object mode')){
        speak('opening search for object mode');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SearchForObject(),
          ),
        );
      }

      else if(_lastWords.contains('open video call assistant mode')){
        speak('opening video call assistant mode');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CallScreenBlind()
          ),
        );
      }

      else if(_lastWords.contains('open read text mode')){
        speak('opening read text mode');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const TextRecognition(),
          ),
        );
      }

      else if(_lastWords.contains('open cloth mode')){
        speak('opening cloth mode');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ClothesDetection(),
          ),
        );
      }

      else if(_lastWords.contains('open face recognize mode')){
        speak('opening face recognize mode');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FaceRecognition(),
          ),
        );
      }

      else if(_lastWords.contains('open which color mode')){
        speak('not available for now');
      }

      else if(_lastWords.contains('open  money mode')){
        speak('opening money mode');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Banknotes(),
          ),
        );
      }


      else if(_lastWords.contains('tell me the features')){
        speak('okay then the features that we have are'
            'open search for object mode'
            'open video call assistant mode'
            'open read text mode'
            'open cloth mode'
            'open face recognize mode'
            'open which color mode'
            'open  money mode'
        );
      }

      else if(_lastWords.contains('explain feature search for object mode')){
        speak('tells you what object is in front of your mobile camera');
      }

      else if(_lastWords.contains('explain feature video call assistant mode')){
        speak('calls a volunteer person and shares your mobile camera'
            'with this person to help you in a certain task');
      }

      else if(_lastWords.contains('explain feature read text mode')){
        speak('which reads any writing in front of your mobile camera');
      }

      else if(_lastWords.contains('explain feature cloth mode')){
        speak('tells you the clothes which is in front of your mobile camera');
      }

      else if(_lastWords.contains('explain feature face recognize mode')){
        speak('tells you who is the person in front of you '
            'by taking a picture of him');
      }

      else if(_lastWords.contains('explain feature which color mode')){
        speak('tells you the color in front of your mobile camera');
      }

      else if(_lastWords.contains('explain feature money mode')){
        speak('tells you how much money is in front of your mobile camera');
      }
      else {
        speak('we did not recognize your command'
            'try again');
      }

    }


  initTts() async {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _speechToText.isNotListening ? _startListening : _stopListening,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black87,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                color: Colors.white,
                size: 100.0,
              ),
              const SizedBox(
                height: 50.0,
              ),
              Text(
                _speechToText.isListening
                    ? _lastWords
                    : _speechEnabled
                    ? 'Tap the microphone to start listening...'
                    : 'Speech not available',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
