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

class OCRapp extends StatefulWidget {
  const OCRapp({
    Key key,
  }) : super(key: key);

  @override
  State<OCRapp> createState() => _OCRappState();
}

class _OCRappState extends State<OCRapp> {
  List<CameraDescription> _cameras;
  CameraController _controller;
  final textDetector = GoogleMlKit.vision.textDetector();
  Socket socket;
  // TextEditingController _itemNameController = TextEditingController();
  Timer timer;
  TTS tts;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    initializeSocket();
    initializeTTS();
    initAudioPlayerCameraSound();
    tts.speak(
        'Welcome to optical character recognition mode'
        'Please focus your mobile towards the document'
        'then double tap on the screen to capture and recognize the document'
            'if you want to return to the main menu of all features '
            'press and hold on the screen');

  }

  void emitImage() async {
    var xFile = await _controller.takePicture();
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
    _controller.dispose();
    destroyAudioPlayerCameraSound();
    super.dispose();
  }

  void initializeCameraController() {
    _controller = CameraController(_cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        _controller.setFocusMode(FocusMode.locked);
        _controller.setFlashMode(FlashMode.off);
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
      scale = 1 / (_controller.value.aspectRatio * size.aspectRatio);
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
      onDoubleTap: ()async {
        var xFile = await _controller.takePicture();
        final Uint8List bytes = await xFile.readAsBytes();
        String img64 = base64Encode(bytes);

        socket?.emit(
          "client:OCR_request",
          {
            // "item_name": _itemNameController.text,
            "image_base64": img64,
          },
        );
        print("send");
        socket?.on("OCR Server: Response", (res) {
          print("received");
          setState(() {
            // for (var i = 0; i < ; i++) {
            tts?.speak(res.toString());
            // }
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
                      scale: scale, child: CameraPreview(_controller)),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 100.0),
                //   child: Align(
                //     alignment: FractionalOffset.bottomCenter,
                //     child: TextField(
                //       controller: _itemNameController,
                //       decoration: InputDecoration(
                //         contentPadding:
                //             const EdgeInsets.symmetric(horizontal: 20.0),
                //         fillColor: Colors.white10,
                //         filled: true,
                //       ),
                //     ),
                //   ),
                // ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child:  Icon(
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
