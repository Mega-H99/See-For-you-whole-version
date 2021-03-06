import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:see_for_you_alpha_version/main_screens/choose-part.dart';

import '../recognition_detection_screens/utils/tts.dart';
import 'audioplayer_bluetooth_alarm.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  TTS tts;

  void initializeTTS() {
    tts = TTS();
  }

  intro() async{
    if(widget.server.name=="HC-06"){
      tts.speak("Connected to smart shoes. "
          "If an obstacle is detected you will hear the alarm. "
          "Therefore you need to change your direction while walking. "
          "If you don't hear the alarm then your track is safe. "
          "Enjoy your walk.  "
          "Long press if you want to exit app.  ");
      Future.delayed(const Duration(seconds: 10),);
    }
    else{
      tts.speak("Connected to wrong device please long press to exit app");
    }
  }


  @override
  void initState() {
    super.initState();
    initializeTTS();
    initAudioPlayerAlarmSound();
    intro();
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occurred');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    destroyAudioPlayerAlarmSound();
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '??\\_(???)_/??' : text;
                }(_message.text.trim()),
                style: const TextStyle(color: Colors.white)),
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return GestureDetector(
      onLongPress: () async{
        tts.speak('Closing app');
        Future.delayed(const Duration(seconds: 3),(){
        }).then((value) => SystemNavigator.pop());


      },
      child: Scaffold(
        appBar: AppBar(
            title: (isConnecting
                ? Text('Connecting chat to ' + widget.server.name + '...')
                : isConnected
                    ? Text('Live chat with ' + widget.server.name)
                    : Text('Chat log with ' + widget.server.name))),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // Container(
              //   padding: const EdgeInsets.all(5),
              //   width: double.infinity,
              //   child: FittedBox(
              //     child: Row(
              //       children: [
              //         FlatButton(
              //           onPressed: isConnected ? () => _sendMessage('1') : null,
              //           child: ClipOval(child: Image.asset('images/ledOn.png')),
              //         ),
              //         FlatButton(
              //           onPressed: isConnected ? () => _sendMessage('0') : null,
              //           child: ClipOval(child: Image.asset('images/ledOff.png')),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Flexible(
                child: ListView(
                    padding: const EdgeInsets.all(12.0),
                    controller: listScrollController,
                    children: list,
                ),
              ),
              // Row(
              //   children: <Widget>[
              //     Flexible(
              //       child: Container(
              //         margin: const EdgeInsets.only(left: 16.0),
              //         child: TextField(
              //           style: const TextStyle(fontSize: 15.0),
              //           controller: textEditingController,
              //           decoration: InputDecoration.collapsed(
              //             hintText: isConnecting
              //                 ? 'Wait until connected...'
              //                 : isConnected
              //                     ? 'Type your message...'
              //                     : 'Chat got disconnected',
              //             hintStyle: const TextStyle(color: Colors.grey),
              //           ),
              //           enabled: isConnected,
              //         ),
              //       ),
              //     ),
              //     Container(
              //       margin: const EdgeInsets.all(8.0),
              //       child: IconButton(
              //           icon: const Icon(Icons.send),
              //           onPressed: isConnected
              //               ? () => _sendMessage(textEditingController.text)
              //               : null),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    if(dataString.contains('DANGER')){
      playMusic();
    }
    else if(dataString.contains('GOOD')){
      pauseMusic();
    }
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
    Future.delayed(const Duration(milliseconds: 333)).then((_) {
      listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut);
    });
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
