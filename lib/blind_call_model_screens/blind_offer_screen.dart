import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../socket.io_cubit/blind_side_cubit.dart';

class BlindOfferScreen extends StatelessWidget {
  const BlindOfferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //BlindCubitSide.get(context).initializeMe();
    //BlindCubitSide.get(context).speak('long press to Start Call');
    return Column(
      children: [
        GestureDetector(
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
        ),
      ],
    );
  }
}
