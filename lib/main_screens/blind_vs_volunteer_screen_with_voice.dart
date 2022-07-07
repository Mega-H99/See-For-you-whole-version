import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../recognition_detection_screens/pages_of_recognition/rushdi_stt_screen.dart';
import 'call_screen_volunteer.dart';

class BlindVSVolunteerScreenWithVoice extends StatefulWidget {
  const BlindVSVolunteerScreenWithVoice({Key? key}) : super(key: key);

  @override
  State<BlindVSVolunteerScreenWithVoice> createState() =>
      _BlindVSVolunteerScreenWithVoiceState();

}

class _BlindVSVolunteerScreenWithVoiceState extends
State<BlindVSVolunteerScreenWithVoice> {

  bool isBlind = false;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initSpeech();
    speak("welcome to see for me "
          "Tap on the screen and say if you are blind or volunteer");
    setState(() {});
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
    print("$_speechEnabled");
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
    if (_lastWords.contains('blind')) {
      isBlind = true;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RushdiSttScreen()),
      );
    } else if (_lastWords.contains('volunteer')) {
      isBlind = false;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CallScreenVolunteer()),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _speechToText.isNotListening ? _startListening : _stopListening,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    'Blind',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.purple,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    'Volunteer',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}