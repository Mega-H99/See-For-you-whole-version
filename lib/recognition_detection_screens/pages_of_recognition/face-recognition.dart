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

class FaceRecognition extends StatefulWidget {
  const FaceRecognition({
    Key? key,
  }) : super(key: key);

  @override
  State<FaceRecognition> createState() => _FaceRecognitionState();
}

class _FaceRecognitionState extends State<FaceRecognition> {
  List<CameraDescription>? _cameras;
  CameraController? _controller;
  final textDetector = GoogleMlKit.vision.textDetector();
  Socket? socket;
  String faceCommand ='';

  Timer? timer;
  TTS? tts;
  List<String>? potentialname;
  String? name;
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
    Future.delayed(const Duration(seconds: 2), () {
      if (_lastWords.contains('ahmed')) {
        Future.delayed(const Duration(seconds: 2), () {
          tts?.speak('hello ahmed');
        });
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    initializeCamera();
    initializeSocket();
    initializeTTS();
    initAudioPlayerCameraSound();
    tts!.speak(
        'Welcome to face recognize mode'
        'Please tap on the screen and say a command like'
        'save or store or remove or delete or identify or verify '
        'followed by the person name'
        'then focus your mobile towards the person you want to recognize'
        'then double tap on the screen to capture and recognize the persons face'
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
      onTap: () async {
        _speechToText.isNotListening ? _startListening : _stopListening;
        faceCommand=_speechToText.isListening
            ? _lastWords
            : _speechEnabled
            ? 'Tap the screen to start listening...'
            : 'Speech not available';
      },
      onLongPress: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SttScreen(),
          ),
        );
      },
      onDoubleTap: () async {
          var xFile = await _controller!.takePicture();
          final Uint8List bytes = await xFile.readAsBytes();
          String img64 = base64Encode(bytes);

          if ((faceCommand.contains('save') |
          faceCommand.contains('store')) &
          !(faceCommand.contains('remove') |
          faceCommand.contains('delete')) &
          !(faceCommand.contains('identify') |
          faceCommand.contains('verify'))) {
            faceCommand.contains('save')
                ? potentialname =
                faceCommand.split('save')
                : potentialname =
                faceCommand.split('store');

            name = potentialname?[1];
            name = name?.trim();
            socket?.emit("client: Save Friend", {
              'data': img64,
              'name': name,
              // _itemNameController.text,
            });
            print("saved");
          } else if ((faceCommand.contains('remove') |
          faceCommand.contains('delete')) &
          !(faceCommand.contains('save') |
          faceCommand.contains('store')) &
          !(faceCommand.contains('identify') |
          faceCommand.contains('verify'))) {
            faceCommand.contains('remove')
                ? potentialname =
                faceCommand.split('remove')
                : potentialname =
                faceCommand.split('delete');
            name = potentialname?[1];
            name = name?.trim();
            socket?.emit("client: Remove Friend", {"name": name});
            print("deleted");
          } else if ((faceCommand.contains('identify') |
          faceCommand.contains('verify')) &
          !(faceCommand.contains('save') |
          faceCommand.contains('store')) &
          !(faceCommand.contains('remove') |
          faceCommand.contains('delete'))) {
            faceCommand.contains('identify')
                ? potentialname =
                faceCommand.split('identify')
                : potentialname =
                faceCommand.split('verify');
            name = potentialname?[1];
            name = name?.trim();
            socket?.emit("client: Verify Friend", {
              "data": img64,
              "name": name,
            });
            print("send");
          }
          // socket?.emit(
          //   "client:search_item",
          //   {
          //     "item_name": _itemNameController.text,
          //     "image_base64": img64,
          //   },
          // );

          socket?.on("faceRecognitionServer: myResponse", (res) {
            print("received");
            setState(() {
              tts?.speak(res);
            });
            print(res);
          });

          // final RecognisedText recognisedText = await textDetector
          //     .processImage(InputImage.fromFile(File(xFile.path)));

          // print(recognisedText.text);
        },
      child: Scaffold(
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
                      child: Text(
                        faceCommand,
                          style:const TextStyle(
                            color: Colors.white10,
                          ),


                        ),
                      ),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Icon(
                      Icons.camera,
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

