import 'package:flutter/material.dart';

import '../socket.io_cubit/blind_side_cubit.dart';
import '../socket.io_cubit/volunteer_side_cubit.dart';

class VolunteerLeavingVideoCallScreen extends StatelessWidget {
  const VolunteerLeavingVideoCallScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/exit.png'),
          const SizedBox(
            height:30.0,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Your Are Leaving Video Call",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 160.0,
              height: 80.0,
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  VolunteerCubitSide.get(context).destroyMe();
                  Navigator.pop(context);
                },
                color: Colors.blue.shade800,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:const [
                    Icon(
                      Icons.missed_video_call_outlined,
                      size: 40.0,
                      color: Colors.white,
                    ),
                    Text('Exit',
                      style:TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
    //   Container(
    //   decoration: const BoxDecoration(
    //       image: DecorationImage(
    //           fit: BoxFit. fill,
    //           image: AssetImage(
    //             'images/closing_call.png',
    //           ))),
    //   child:   Center(
    //     child: Column(
    //       children: [
    //         const Text(
    //           "Your Are Leaving Video Call",
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
    //             VolunteerCubitSide.get(context).destroyMe();
    //             Navigator.pop(context);
    //           },
    //           color: Colors.red,
    //           icon: const Icon(
    //             Icons.missed_video_call_outlined,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ],
    //     ),
    //
    //   ),
    // );
  }
}
