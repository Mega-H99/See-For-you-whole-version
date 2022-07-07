import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/pages_of_recognition/stt_screen.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/utils/audioplayer_camera.dart';
import 'package:see_for_you_alpha_version/recognition_detection_screens/utils/tts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchForObject extends StatefulWidget {
  const SearchForObject({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchForObject> createState() => _SearchForObjectState();
}

class _SearchForObjectState extends State<SearchForObject> {
  List<CameraDescription>? _cameras;
  CameraController? _controller;
  final textDetector = GoogleMlKit.vision.textDetector();
  String objectName='';
  Socket? socket;
  Timer? timer;
  TTS? tts;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';



  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    print('hello i am listening');
    await _speechToText.listen(onResult: _onSpeechResult, localeId: "en_US");
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    print('hello i stopped listening');
    await _speechToText.stop();
    setState(() {});
  }


  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    print('hello');
    setState(() {
      _lastWords = result.recognizedWords;
      print(_lastWords);
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (_lastWords.isNotEmpty) {
        Future.delayed(const Duration(seconds: 2), () {
          print(_lastWords);
          setState(() {
          objectName=_lastWords;
          });
        });
      }
      setState(() {});
    });
  }
  @override
  void initState() {
    super.initState();
    _initSpeech();
    initializeCamera();
    initializeSocket();
    initializeTTS();
    initAudioPlayerCameraSound();
    tts!.speak(
        'Welcome to search for an object mode'
            'Please tap on the screen and say the name of the object you are'
            'searching for '
            'then focus your mobile towards an object'
            'and double tap on the screen to capture and recognize the object'
            'if you want to return to the main menu of all features '
            'press and hold on the screen');
  }

  void emitImage() async {
    var xFile = await _controller!.takePicture();
    final Uint8List bytes = await xFile.readAsBytes();
    String img64 = base64Encode(bytes);

    socket?.emit("my event", {"data": img64});
    socket?.on("my response", (res) => print(res));
  }

  void initializeSocket() {
    socket = IO.io(
        'http://192.168.1.7:5000/',
        OptionBuilder().setTransports([
          "websocket",
        ]).build());
    socket?.onConnect((data) {
      print('connected');
    });
    print(socket);
  }

  void initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();

    initializeCameraController();
  }

  void initializeTTS() {
    tts = TTS();
  }

  @override
  void dispose() {
    _controller!.dispose();
    destroyAudioPlayerCameraSound();
    super.dispose();
  }

  void initializeCameraController() {
    _controller = CameraController(_cameras![0], ResolutionPreset.max);
    _controller!.initialize().then((_) {
      if (!mounted) {
        _controller!.setFocusMode(FocusMode.locked);
        _controller!.setFlashMode(FlashMode.off);
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double scale = 0.0;
    if (_controller != null) {
      scale = 1 / (_controller!.value.aspectRatio * size.aspectRatio);
    }

    return GestureDetector(
      onLongPress: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SttScreen(),
          ),
        );
      },
      onTap: _speechToText.isNotListening ? _startListening : _stopListening,
      onDoubleTap: ()async {
        playMusic();
        var xFile = await _controller!.takePicture();
        final Uint8List bytes = await xFile.readAsBytes();
        String img64 = base64Encode(bytes);
        if(objectName.isNotEmpty) {
          socket?.emit(
            "client:search_item",
            {
              "item_name": objectName,
              "image_base64": img64,
            },
          );
          print("send");
          socket?.on("my response", (res) {
            print("received");
            setState(() {
              tts?.speak(res);
            });
            print(res);
          });
        }
        // final RecognisedText recognisedText = await textDetector
        //     .processImage(InputImage.fromFile(File(xFile.path)));

        // print(recognisedText.text);
      },
      child:
      objectName.isNotEmpty?
      Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SafeArea(
            child: Stack(
              children: [
                if (_controller != null)
                  Transform.scale(
                      scale: scale, child: CameraPreview(_controller!)),
                const Padding(
                  padding: EdgeInsets.only(bottom: 100.0),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Tap on the screen to record object name",
                        style: TextStyle(
                          color: Colors.white24,
                        ),
                        ),
                      ),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child:Icon(Icons.camera,
                      size: 60.0,
                      color: Colors.white,

                    ),
                      ),
                  ),
              ],
            ),
          ),
        ),
      ):
      Scaffold(
        body: SizedBox(
    width: size.width,
    height: size.height,
    child: SafeArea(
    child: Stack(
    children: [
    if (_controller != null)
    Transform.scale(
    scale: scale, child: CameraPreview(_controller!)),
     Padding(
    padding: const EdgeInsets.only(bottom: 100.0),
    child: Align(
    alignment: FractionalOffset.bottomCenter,
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Text('pen',
      //objectName,
    style: const TextStyle(
    color: Colors.white24,
    ),
    ),
    ),
    ),
    ),
    const Padding(
    padding: EdgeInsets.only(bottom: 20.0),
    child: Align(
    alignment: FractionalOffset.bottomCenter,
    child:Icon(Icons.camera,
    size: 60.0,
    color: Colors.white,

    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    );
  }
}
