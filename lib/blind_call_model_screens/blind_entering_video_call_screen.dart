import 'dart:async';

import 'package:flutter/material.dart';
import 'package:see_for_you_alpha_version/socket.io_cubit/blind_side_cubit.dart';


class BlindNotReadyScreen extends StatelessWidget {
  const BlindNotReadyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlindCubitSide.get(context).
    speak("Ready to start video call double tap to enter");
    return  GestureDetector(
      onDoubleTap: (){
        BlindCubitSide.get(context).speak('Entering Video Call');
        BlindCubitSide.get(context).screenIndex=1;
        //BlindCubitSide.get(context).initializeMe();
      },
      onTap: (){
        BlindCubitSide.get(context).
        speak("Ready to start video call double tap to enter");
      },
      child:Container(
        color: Colors.blueGrey.shade300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
          Center(
            child: Image.asset(
              'assets/images/blind2.png',
            ),
          ),

          const SizedBox(
            height:30.0,
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Your Are Entering Video Call",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),


          ],
        ),
      ),
      // Container(
      //   decoration: const BoxDecoration(
      //       image: DecorationImage(
      //           fit: BoxFit.fill,
      //           image: AssetImage(
      //               'assets/images/blind2.png',
      //           ))),
      //   child:  const Center(
      //     child: Text(
      //           "Your Are Entering Video Call",
      //           maxLines: 2,
      //           overflow: TextOverflow.ellipsis,
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 40.0,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //
      //     ),
      //   ),

    );
  }
}
