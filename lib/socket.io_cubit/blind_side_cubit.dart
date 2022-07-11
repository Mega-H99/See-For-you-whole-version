import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:see_for_you_alpha_version/socket.io_cubit/blind_states.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../blind_call_model_screens/blind_in_call_screen.dart';
import '../blind_call_model_screens/blind_entering_video_call_screen.dart';
import '../blind_call_model_screens/blind_leaving_Video_call_screen.dart';
import '../blind_call_model_screens/blind_offer_screen.dart';
import '../blind_call_model_screens/blind_ringing_screen.dart';

class BlindCubitSide extends Cubit<BlindStates> {
  BlindCubitSide() : super(BlindInitialState());
  // to be more easier when using this cubit in many places
  static BlindCubitSide get(context) => BlocProvider.of(context);

  List<Widget> blindCallWidgets = [
    const BlindNotReadyScreen(), //0
    const BlindOfferScreen(), //1
    const BlindCallingScreen(), //2
    const BlindInCallScreen(), //3
    const BlindLeavingVideoCallScreen(), //4
  ];

  ringingScreen() {
    screenIndex = 2;
    emit(BlindRingingState());
    Future.delayed(const Duration(seconds: 60), () {
      pauseMusic();
      timeout = true;
      if (noAnswer) {
        if (callRetries == 0) {
          callRetries++;
          createOffer();
        } else {
          callRetries = 0;
          screenIndex = 1;
          speak('No volunteer available please try again in a few seconds');
          emit(BlindCallingTimeoutState());
        }
      }
      // if (noAnswer) {
      //   pauseMusic();
      //   timeout = true;
      //   screenIndex = 1;
      //   speak('no one answered try again');
      //   emit(BlindCallingTimeoutState());
      // }
    });
  }

  int screenIndex = 0;
  bool noAnswer = true;
  int callRetries = 0;

  String blindId;
  String roomId;
  String volunteerID;
  String blindSdp;

  bool _offer = false;
  RTCPeerConnection _peerConnection;
  MediaStream _localStream;
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

   Socket socket;
  bool timeout = true;
  FlutterTts flutterTts = FlutterTts();

  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState playerState = PlayerState.PAUSED;
  AudioCache audioCache;
  String path = 'assets/ringtones/app_running.mp3';

  IconData muted = Icons.mic;
  IconData deafened = Icons.headset;
  IconData whichCamera = Icons.flip_camera_ios;
  IconData videoOff = Icons.videocam;

  Color colorMuted = Colors.white;
  Color colorDeafen = Colors.white;
  Color colorVideoOff = Colors.white;

  bool isMute = false;
  bool isDeafen = false;
  bool isVideoOff = false;

  bool changer = false;

  bool isAllInitializedChecker = false;
  bool isPartialInitializedChecker = false;

// first & last step in video call.

  initializeMe() {
    screenIndex = 1;
    isMute = false;
    isDeafen = false;
    isVideoOff = false;
    changer = false;
    _offer = false;
    callRetries = 0;
    noAnswer = true;
    initRenderer();
    _initSocketConnection();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });
    initTts();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      playerState = s;
      emit(BlindPlayerStateChangedState());
    });
    emit(BlindFullInitializedState());
  }

  destroyMe() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    socket.disconnect();
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache?.clearAll();
    isAllInitializedChecker=false;
    isPartialInitializedChecker= false;
    emit(BlindDisposeState());
  }

// for sounds in video call.

  playMusic() async {
    await audioCache?.loop(path);
    emit(BlindPlayMusicState());
  }

  pauseMusic() async {
    await audioPlayer.pause();
    emit(BlindPauseMusicState());
  }

  speak(String wordsToSay) async {
    await flutterTts.speak(wordsToSay);
    emit(BlindTtsSpeakingState());
  }

// for initializing the video call on blind side.

  initRenderer() async {
    await localRenderer.initialize().then((value) => isAllInitializedChecker=true,);
    await remoteRenderer.initialize();
  }

  initTts() async {
    await flutterTts.setLanguage("en-us");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.awaitSpeakCompletion(true);
  }

  _initSocketConnection() {
    //ws://ad30-41-234-2-218.ngrok.io/
    socket = io(
      'http://192.168.1.2:5000',
      //'http://3264-41-233-95-226.ngrok.io /',
      OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
          .build(),
    ).open();
    socket.onConnect((_) {
      print("connected");
      blindId = socket.id;
      print("connected to server with id:$blindId");

      socket.on('server: Call ended', (_) {
        print("volunteer closed");
        // screenIndex = 1;
        screenIndex = 4;
        // smallDispose();
        initializeMe();
        // initializeMe();
        emit(BlindReceivingACloseCall());
      });
      socket.on("server: no volunteer found", (_) {
        print("server: no volunteer found");
        if (callRetries < 3) {
          Future.delayed(const Duration(seconds: 10), () {
            socket.emit("blind: send sdp", blindSdp);
          });
          callRetries++;
          emit(BlindCallRetrystate());
        } else if (callRetries >= 3) {
          // callRetries = 0;
          initializeMe();
          pauseMusic();
          speak('No volunteer found please try again later');
          emit(BlindCallFailedstate());
        }
      });
      changer = false;
    });
  }

// for setting sdps and candidates on blind side.

  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

    pc.addStream(_localStream);

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ' + stream.id);
      remoteRenderer.srcObject = stream;
    };

    return pc;
  }

  _getUserMedia() async {
    final Map<String, dynamic> constraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    };

    MediaStream stream = await navigator.mediaDevices.getUserMedia(constraints);

    localRenderer.srcObject = stream;

    return stream;
  }

  createOffer() async {
    RTCSessionDescription description =
        await _peerConnection.createOffer({'offerToReceiveVideo': 1});
    blindSdp = description.sdp;
    socket.emit("blind: send sdp", blindSdp);
    print("sending sdp...");
    _offer = true;
    // handleReceivingNoVolunteerFound(blindSdp);
    _peerConnection.setLocalDescription(description);
    emit(BlindSettingLocalDescriptionState());
    _handleReceivingVolunteerCandidate();
    playMusic();
    timeout = false;
    emit(BlindCreatesOfferState());
  }

  Future<void> _setRemoteDescription(String sdp) async {
    RTCSessionDescription description =
        RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    print('Remote Description is set');

    await _peerConnection.setRemoteDescription(description);
    changer = true;
    emit(BlindSettingRemoteDescriptionState());
  }

// for handling various states

  void handleReceivingNoVolunteerFound(String blindSdp) {
    socket.on("server: no volunteer found", (_) {
      print("server: no volunteer found");
      if (callRetries < 3) {
        Future.delayed(const Duration(seconds: 10), () {
          socket.emit("blind: send sdp", blindSdp);
        });
        callRetries++;
        emit(BlindCallRetrystate());
      } else if (callRetries >= 3) {
        // callRetries = 0;
        initializeMe();
        pauseMusic();
        speak('No volunteer found please try again later');
        emit(BlindCallFailedstate());
      }
    });
    changer = false;
  }

  void _handleReceivingVolunteerCandidate() {
    socket.on('server: send volunteer candidate and sdp',
        (volunteerInformation) async {
      Map<String, dynamic> volunteerCandidate =
          volunteerInformation['candidate'] as Map<String, dynamic>;

      String volunteerSdp = volunteerInformation['sdp'] as String;
      volunteerID = volunteerInformation['id'];

      RTCIceCandidate candidate = RTCIceCandidate(
        volunteerCandidate['candidate'],
        volunteerCandidate['sdpMid'],
        volunteerCandidate['sdpMlineIndex'],
      );
      print('recieving sdp...');
      await _setRemoteDescription(volunteerSdp);
      print('Remote sdp is set');
      await _peerConnection.addCandidate(candidate);
      print('candidate is set');
      emit(BlindReceivingVolunteerRemoteInfo());
      if (!timeout) {
        screenIndex = 3;
        noAnswer = false;
        pauseMusic();
        emit(BlindCallingAnsweredState());
      }
    });
  }

// for using call features on blind side

  void mute() {
    if (_peerConnection.getRemoteStreams()[0].getAudioTracks()[0].enabled) {
      _localStream.getAudioTracks()[0].enabled =
          !_localStream.getAudioTracks()[0].enabled;
    }
    muted =
        _localStream.getAudioTracks()[0].enabled ? Icons.mic : Icons.mic_off;

    colorMuted =
        _localStream.getAudioTracks()[0].enabled ? Colors.white : Colors.red;

    isMute = _localStream.getAudioTracks()[0].enabled;

    emit(BlindChangeMuteState());
  }

  void deafen() {
    if ((_localStream.getAudioTracks()[0].enabled &&
            _peerConnection
                .getRemoteStreams()[0]
                .getAudioTracks()[0]
                .enabled) ||
        (!_localStream.getAudioTracks()[0].enabled &&
            !_peerConnection
                .getRemoteStreams()[0]
                .getAudioTracks()[0]
                .enabled)) {
      _localStream.getAudioTracks()[0].enabled =
          !_localStream.getAudioTracks()[0].enabled;

      _peerConnection.getRemoteStreams()[0].getAudioTracks()[0].enabled =
          !_peerConnection.getRemoteStreams()[0].getAudioTracks()[0].enabled;
    } else if (!_localStream.getAudioTracks()[0].enabled &&
        _peerConnection.getRemoteStreams()[0].getAudioTracks()[0].enabled) {
      _peerConnection.getRemoteStreams()[0].getAudioTracks()[0].enabled =
          !_peerConnection.getRemoteStreams()[0].getAudioTracks()[0].enabled;
    }
    deafened = (_localStream.getAudioTracks()[0].enabled &&
            _peerConnection.getRemoteStreams()[0].getAudioTracks()[0].enabled)
        ? Icons.headset
        : Icons.headset_off;

    muted =
        _localStream.getAudioTracks()[0].enabled ? Icons.mic : Icons.mic_off;

    colorDeafen = (_localStream.getAudioTracks()[0].enabled &&
            _peerConnection.getRemoteStreams()[0].getAudioTracks()[0].enabled)
        ? Colors.white
        : Colors.red;

    isDeafen = (_localStream.getAudioTracks()[0].enabled &&
        _peerConnection.getRemoteStreams()[0].getAudioTracks()[0].enabled);

    emit(BlindChangeDeafenState());
  }

  void switchCamera() async {
    try {
      await _localStream.getVideoTracks()[0].switchCamera();
    }catch(e){print(e.toString());}
    whichCamera = Icons.flip_camera_ios;
    emit(BlindChangeCameraState());
  }

  void videoChange() {
    _localStream.getVideoTracks()[0].enabled =
        !_localStream.getVideoTracks()[0].enabled;

    videoOff = _localStream.getVideoTracks()[0].enabled
        ? Icons.videocam
        : Icons.videocam_off;

    colorVideoOff =
        _localStream.getVideoTracks()[0].enabled ? Colors.white : Colors.red;

    isVideoOff = !_localStream.getVideoTracks()[0].enabled;

    emit(BlindChangeVideoState());
  }

  void smallDispose() {
    socket.emit("blind: Call ended", volunteerID);
    emit(BlindCloseCallState());
  }

  void handleVolunteerClosingCall() {


    
  }
}
