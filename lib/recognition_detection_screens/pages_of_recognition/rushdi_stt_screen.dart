
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:see_for_you_alpha_version/blind_call_model_screens/blind_ringing_screen.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/OCR.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/banknotes-recognition.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/cloth-detection.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/color-detection.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/face-recognition.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/places-recognition.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/search-for-object.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../main_screens/call_blind_screen.dart';
import '../utils/tts.dart';

class RushdiSttScreen extends StatefulWidget {
  const RushdiSttScreen({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RushdiSttScreen> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  TTS tts;

  void initializeTTS() {
    tts = TTS();
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    initializeTTS();
    tts.speak("Welcome see for me assistant mode.  ");
    setState(() {});
  }
  @override
  void dispose() {
    _speechToText;
    super.dispose();
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


  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    if (_lastWords.contains('face')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FaceRecognition()),
      );
    } else if (_lastWords.contains('object')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchForObject()),
      );
    } else if (_lastWords.contains('cloth')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ClothesDetection()),
      );
    } else if (_lastWords.contains('text')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OCRapp()),
      );
    } else if (_lastWords.contains('money')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Banknotes()),
      );
    } else if (_lastWords.contains('colour')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RecognizeColor()),
      );
    }
    else if (_lastWords.contains('place')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PlacesScreen()),
      );
    }
    else if (_lastWords.contains('video')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CallScreenBlind()),
      );
    }
    else if (_lastWords.contains('exit app')) {
      SystemNavigator.pop();
    }
    // else {
    //   Future.delayed(Duration(seconds: 5), () {
    //     speak('again please');
    //   });
    // }
    setState(() {});
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
