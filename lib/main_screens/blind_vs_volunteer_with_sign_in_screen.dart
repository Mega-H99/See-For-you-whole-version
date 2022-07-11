
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:see_for_you_alpha_version/firebase_authentication_part/sign-in_part/logged_in_widget.dart';
import 'package:see_for_you_alpha_version/firebase_authentication_part/sign-in_part/sign_up_widget.dart';

class BlindVSVolunteerNewScreen extends StatefulWidget {
  const BlindVSVolunteerNewScreen({Key key}) : super(key: key);

  @override
  _BlindVSVolunteerNewScreenState createState() => _BlindVSVolunteerNewScreenState();
}

class _BlindVSVolunteerNewScreenState extends State<BlindVSVolunteerNewScreen> {


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center (child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return const Center(child: Text('Something Went Wrong!',),);
          }
          else if (snapshot.hasData) {

            return const LoggedInWidget();
          }
          else {
            return const SignUpWidget();
          }
        },
      ),

    );
  }
}





