import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../socket.io_cubit/blind_side_cubit.dart';

class BlindOfferScreen extends StatefulWidget {
  const BlindOfferScreen({Key key}) : super(key: key);

  @override
  State<BlindOfferScreen> createState() => _BlindOfferScreenState();
}

class _BlindOfferScreenState extends State<BlindOfferScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //BlindCubitSide.get(context).initializeMe();
    if (!_isLoading) {
      BlindCubitSide.get(context).speak(
          'Now you are ready long press to Start Call');
      return GestureDetector(
        onLongPress: () {
          print('Blind Calling Other Volunteers');
          BlindCubitSide.get(context).speak('Starting Call');
          BlindCubitSide.get(context).ringingScreen();
          BlindCubitSide.get(context).createOffer();
        },
        child: Column(
          children: [
            SizedBox(
                height: 500,
                child: Row(children: [
                  Flexible(
                    child: Container(
                        key: const Key("local"),
                        margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        decoration: const BoxDecoration(color: Colors.black),
                        child: RTCVideoView(
                          BlindCubitSide.get(context).localRenderer,
                          mirror: true,
                        )),
                  ),
                ])),
            const SizedBox(
              height: 20.0,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  // Text(
                  //   'Waiting for blind user to call ',
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                ]),
          ],
        ),
      );
    }

    else{
    BlindCubitSide.get(context).speak('Loading your video camera please wait');
       print('trying to build offical screen');
         return Center(
          child:Image.asset('assets/images/loadingGIF.gif') ,
        );
       }
     }
}
