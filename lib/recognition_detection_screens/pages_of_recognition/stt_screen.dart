import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:see_for_you_alpha_version/main_screens/call_blind_screen.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/banknotes-recognition.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/cloth-detection.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/color-detection.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/face-recognition.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/search-for-object.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/text-read.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SttScreen extends StatefulWidget {
  const SttScreen({Key key,}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SttScreen> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  FlutterTts flutterTts = FlutterTts();
  // bool tutorialsNeeded = true;
  int timeoutForChoosingCommand = 1;
  bool commandDone=false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    initTts();
    greetings();
    }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }
 instructions(){
   //if(tutorialsNeeded) {
     // Future.delayed((const Duration(seconds: 4)), () {
     //   speak("We are happy to help you with your daily activities");
     // }).then((_) {
     //   Future.delayed((const Duration(seconds: 4)), () {
     //     speak("for that let us tell you our various features "
     //         "that you can use and how to use it");
     //   }).then((_) {
     //     Future.delayed((const Duration(seconds: 4)), () {
     //       speak(
     //           "for that we will tell you the steps of how to use every feature");
     //     }).then((_) {
     //       Future.delayed((const Duration(seconds: 4)), () {
     //         speak("First things first"
     //             "The features that you can use are");
     //       }).then((_) {
     //         Future.delayed((const Duration(seconds: 4)), () {
     //           speak("one search for object mode");
     //         }).then((_) {
     //           Future.delayed((const Duration(seconds: 4)), () {
     //             speak(
     //                 "which tells you what object is in front of your mobile camera");
     //           }).then((_) {
     //             Future.delayed((const Duration(seconds: 4)), () {
     //               speak("two video call assistant mode");
     //             }).then((_) {
     //               Future.delayed((const Duration(seconds: 4)), () {
     //                 speak(
     //                     "which calls a volunteer person and shares your mobile camera");
     //               }).then((_) {
     //                 Future.delayed((const Duration(seconds: 4)), () {
     //                   speak(
     //                       "with this person to help you in a certain task");
     //                 }).then((_) {
     //                   Future.delayed((const Duration(seconds: 4)), () {
     //                     speak("three read text mode");
     //                   }).then((_) {
     //                     Future.delayed((const Duration(seconds: 4)), () {
     //                       speak(
     //                           "which reads any writing in front of your mobile camera");
     //                     }).then((_) {
     //                       Future.delayed((const Duration(seconds: 4)), () {
     //                         speak("four cloth mode");
     //                       }).then((_) {
     //                         Future.delayed((const Duration(seconds: 4)), () {
     //                           speak(
     //                               "tells you the clothes which is in front of your mobile camera");
     //                         }).then((_) {
     //                           Future.delayed((const Duration(seconds: 4)), () {
     //                             speak("fifth face recognize mode");
     //                           }).then((_) {
     //                             Future.delayed(
     //                                 (const Duration(seconds: 4)), () {
     //                               speak(
     //                                   "tells you who is the person in front of you by taking a picture of him");
     //                             }).then((_) {
     //                               Future.delayed(
     //                                   (const Duration(seconds: 4)), () {
     //                                 speak("sixth which color mode");
     //                               }).then((_) {
     //                                 Future.delayed(
     //                                     (const Duration(seconds: 4)), () {
     //                                   speak(
     //                                       "tells you the color in front of your mobile camera");
     //                                 }).then((_) {
     //                                   Future.delayed(
     //                                       (const Duration(seconds: 4)), () {
     //                                     speak("seventh money mode");
     //                                   }).then((_) {
     //                                     Future.delayed(
     //                                         (const Duration(seconds: 4)), () {
     //                                       speak(
     //                                           "tells you how much money is in front of your mobile camera");
     //                                     }).then((_) {
                                           Future.delayed((const Duration(
                                               seconds: 4)), () {
                                             //"you can also use three more voice commands which are"
                                             speak(
                                                 "You are using voice assistant that have three commands to use");
                                           }).then((_) {
                                             Future.delayed((const Duration(
                                                 seconds: 4)), () {
                                               speak(
                                                   "First voice command "
                                                   "tell me the features");
                                             }).then((_) {
                                               Future.delayed((const Duration(
                                                   seconds: 4)), () {
                                                 speak(
                                                     "Second voice command"
                                                     "explain feature followed by the feature name");
                                               }).then((_) {
                                                 Future.delayed((const Duration(
                                                     seconds: 4)), () {
                                                   speak(
                                                       "Third voice command"
                                                       "exit app");
                                                 }).then((_) {
                                                   Future.delayed(
                                                       (const Duration(
                                                           seconds: 4)), () {
                                                     speak(
                                                         "here you go know you can use the app");
                                                   }).then((_) {
                                                     Future.delayed(
                                                         const Duration(
                                                             seconds: 4), () {
                                                       speak("Tap on the screen to choose one of the three commands");

                                                     // }).then((_) {
                                                     //   Future.delayed(
                                                     //       const Duration(
                                                     //           seconds: 4), () {
                                                     //     speak(
                                                     //         "just tap and say open followed by the name of the feature and tap again");
                                                     //   }).then((_) {
                                                     //     Future.delayed(
                                                     //         const Duration(
                                                     //             seconds: 4), () {
                                                     //       speak(
                                                     //           "Then we will open that feature for you and continue the journey");
                                                     //     }).then((_) {
                                                     //       Future.delayed(
                                                     //           const Duration(
                                                     //               seconds: 4), () {
                                                     //         speak(
                                                     //             "Lets try it now for example tap and say open video call assistant mode");
                                                     //       });
                                                     //     });
                                                     //   });
                                                     // });
                                                   });
                                                 });
                                               });
                                             });
                                           });
                                          });
     //                                   });
     //                                 });
     //                               });
     //                             });
     //                           });
     //                         });
     //                       });
     //                     });
     //                   });
     //                 });
     //               });
     //             });
     //           });
     //         });
     //       });
     //     });
     //   });
     // });
   // }
   // else if (!tutorialsNeeded) {
   //   speak('Welcome again');
   // }
 }

 chosenCommand(){
   print(_speechToText.isListening.toString());
   print(_speechToText.hasRecognized.toString());
   print(_lastWords);
   Future.delayed(const Duration(seconds: 10)).
     then((_) {
       if (_lastWords.contains('open search for object mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('opening search for object mode');
         }).then((_) {
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => const SearchForObject(),
             ),
           );
         });
       }

       else if (_lastWords.contains('open video call assistant mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('opening video call assistant mode');
         }).then((_) {
           Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context) => const CallScreenBlind()
             ),
           );
         });
       }

       else if (_lastWords.contains('open read text mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('opening read text mode');
         }).then((_) {
           Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context) => const TextRecognition()
             ),
           );
         });
       }

       else if (_lastWords.contains('open cloth mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('opening cloth mode');
         }).then((_) {
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => const ClothesDetection(),
             ),
           );
         });
       }

       else if (_lastWords.contains('open face recognize mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('opening face recognize mode');
         }).then((_) {
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => const FaceRecognition(),
             ),
           );
         });
       }

       else if (_lastWords.contains('open which colour mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('opening which colour mode');
         }).then((_) {
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => const RecognizeColor(),
             ),
           );
         });
       }

       else if (_lastWords.contains('open money mode')) {
         print('money money money');
         commandDone=true;
         print('$commandDone');
         Future.delayed(const Duration(seconds: 4), () {
           speak('opening money mode');
         }).then((_) {
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => const Banknotes(),
             ),
           );
         });
       }

       else if (_lastWords.contains('tell me the features')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak("okay then the features that we have are");
         }).then((_) {
           Future.delayed(const Duration(seconds: 4), () {
             speak("open search for object mode");
           }).then((_) {
             Future.delayed(const Duration(seconds: 4), () {
               speak("open video call assistant mode");
             }).then((_) {
               Future.delayed(const Duration(seconds: 4), () {
                 speak("open read text mode");
               }).then((_) {
                 Future.delayed(const Duration(seconds: 4), () {
                   speak("open cloth mode");
                 }).then((_) {
                   Future.delayed(const Duration(seconds: 4), () {
                     speak("open face recognize mode");
                   }).then((_) {
                     Future.delayed(const Duration(seconds: 4), () {
                       speak("open which color mode");
                     }).then((_) {
                       Future.delayed(const Duration(seconds: 4), () {
                         speak("open  money mode");
                       });
                     });
                   });
                 });
               });
             });
           });
         });
       }

       else if (_lastWords.contains('explain feature search for object mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('tells you what object is in front of your mobile camera');
         });
       }

       else if (_lastWords.contains('explain feature video call assistant mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('calls a volunteer person and shares your mobile camera'
               'with this person to help you in a certain task');
         });
       }

       else if (_lastWords.contains('explain feature read text mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('which reads any writing in front of your mobile camera');
         });
       }

       else if (_lastWords.contains('explain feature cloth mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak(
               'tells you the clothes which is in front of your mobile camera');
         });
       }

       else if (_lastWords.contains('explain feature face recognize mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('tells you who is the person in front of you '
               'by taking a picture of him');
         });
       }

       else if (_lastWords.contains('explain feature which color mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('tells you the color in front of your mobile camera');
         });
       }

       else if (_lastWords.contains('explain feature money mode')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('tells you how much money is in front of your mobile camera');
         });
       }

       else if (_lastWords.contains('exit app')) {
         commandDone=true;
         Future.delayed(const Duration(seconds: 4), () {
           speak('closing the app bye');
         }).then((_) => SystemNavigator.pop());
       }

       else {
         print('timeoutForChoosingCommand: $timeoutForChoosingCommand');
         print('commandDone: $commandDone');
       Future.delayed(const Duration(seconds: 4),(){
         speak('we did not recognize your command'
             'try again');
       }).then((_){
         if(timeoutForChoosingCommand<3 && commandDone==false) {
           timeoutForChoosingCommand++;
         }
         else{
           SystemNavigator.pop();
         }
       });

       }
     });
   }


 greetings() {
    Future.delayed((const Duration(seconds:4)),(){
      speak("welcome to blind assistant");
    }).then((_) {
      //instructions();
      print('instructions goes here');
    });
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
    chosenCommand();
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
