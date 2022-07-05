import 'package:flutter/material.dart';
import 'package:see_for_you_alpha_version/socket.io_cubit/volunteer_side_cubit.dart';
import 'package:socket_io_client/socket_io_client.dart';

class VolunteerCallingScreen extends StatelessWidget {
  const VolunteerCallingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade300,
      child: Center(
        child: SizedBox(
          width: 400,
          height: 600,
          child: Column(
            children: [
              const SizedBox(
                height: 300.0,
              ),
              CircleAvatar(
                child: Image.asset('assets/images/eye.png'),
              ),
              const Text(
                'Blind User is Calling ...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 300.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      onPressed: () {
                        VolunteerCubitSide.get(context).isBusy = true;
                        VolunteerCubitSide.get(context).noAnswer = false;
                        // VolunteerCubitSide.get(context).receivingCall = false;
                        VolunteerCubitSide.get(context).notifyOtherVolunteers();
                        VolunteerCubitSide.get(context).pauseMusic();
                        VolunteerCubitSide.get(context).screenIndex = 3;
                        VolunteerCubitSide.get(context).setRemoteDescription(
                          VolunteerCubitSide.get(context).blindSdp);
                        VolunteerCubitSide.get(context).createAnswer();
                      },
                      icon: const Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: IconButton(
                      onPressed: () {
                        VolunteerCubitSide.get(context).noAnswer = false;
                        VolunteerCubitSide.get(context).receivingCall = false;
                        VolunteerCubitSide.get(context).screenIndex = 1;
                        VolunteerCubitSide.get(context).pauseMusic();
                      },
                      icon: const Icon(
                        Icons.call_end,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
