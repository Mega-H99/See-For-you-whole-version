
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'connection.dart';
import 'led.dart';

class BluetoothScreen extends StatelessWidget {
  const BluetoothScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FlutterBluetoothSerial.instance.requestEnable(),
    builder: (context, future) {
    if (future.connectionState == ConnectionState.waiting) {
    return const Scaffold(
    body: SizedBox(
    height: double.infinity,
    child: Center(
    child: Icon(
    Icons.bluetooth_disabled,
    size: 200.0,
    color: Colors.blue,
    ),
    ),
    ),
    );
    } else if (future.connectionState == ConnectionState.done) {
    // return MyHomePage(title: 'Flutter Demo Home Page');
    return Home();
    } else {
    return Home();
    }
    },
    );
  }
}
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Connection'),
          ),
          body: SelectBondedDevicePage(
            onCahtPage: (device1) {
              BluetoothDevice device = device1;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChatPage(server: device);
                  },
                ),
              );
            },
          ),
        ));
  }
}