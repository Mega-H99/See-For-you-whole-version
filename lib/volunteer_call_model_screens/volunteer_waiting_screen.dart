import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:see_for_you_alpha_version/socket.io_cubit/volunteer_side_cubit.dart';
import '../socket.io_cubit/blind_side_cubit.dart';

class VolunteerWaitingScreen extends StatefulWidget {
  const VolunteerWaitingScreen({Key key}) : super(key: key);

  @override
  State<VolunteerWaitingScreen> createState() => _VolunteerWaitingScreenState();
}

class _VolunteerWaitingScreenState extends State<VolunteerWaitingScreen> {
bool isLocalSet = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3),(){
      setState(() {
        isLocalSet=true;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return isLocalSet?
    Column(
      children: [
        SizedBox(
            height: 500,
            child: Row(children: [
              Flexible(
                child: Container(
                    key: const Key("local"),
                    margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    decoration: const BoxDecoration(color: Colors.black),
                    child:
                    RTCVideoView(
                      VolunteerCubitSide.get(context).localRenderer,
                      mirror: true,
                    ),
                ),
              ),
            ])),
        const SizedBox(
          height: 20.0,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: const [
          Text(
            'Waiting for blind user to call ',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          CircularProgressIndicator(
            color: Colors.grey,
          ),
        ]),
      ],
    ):Center(
    child: Image.asset('assets/images/loadingGIF.gif'),
    );
  }
}
