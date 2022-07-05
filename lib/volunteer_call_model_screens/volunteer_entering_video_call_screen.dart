import 'package:flutter/material.dart';
import '../socket.io_cubit/volunteer_side_cubit.dart';

class VolunteerNotReadyScreen extends StatelessWidget {
  const VolunteerNotReadyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Center(
            child: Image.asset(
              'assets/images/helping-hand.png',
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
          const SizedBox(
            height:30.0,
          ),
          IconButton(
             onPressed: () {
                VolunteerCubitSide.get(context).screenIndex=1;
                 VolunteerCubitSide.get(context).initializeMe();
               },
               color: Colors.amber,
               icon: const Icon(
                 Icons.video_call,
                 color: Colors.white,
               ),
             ),

        ],
      ),
    );
    //   Container(
    //   decoration: const BoxDecoration(
    //       image: DecorationImage(
    //           fit: BoxFit.fill,
    //           image: AssetImage(
    //             'images/entering_call.png',
    //           ))),
    //   child:   Center(
    //     child: Column(
    //       children:  [
    //         const Text(
    //           "Your Are Entering Video Call",
    //           maxLines: 2,
    //           overflow: TextOverflow.ellipsis,
    //           style: TextStyle(
    //             color: Colors.white,
    //             fontSize: 40.0,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         IconButton(
    //           onPressed: () {
    //             VolunteerCubitSide.get(context).screenIndex=1;
    //             VolunteerCubitSide.get(context).initializeMe();
    //           },
    //           color: Colors.amber,
    //           icon: const Icon(
    //             Icons.video_call,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
