import 'package:socket_io_client/socket_io_client.dart';

class SocketIO {
   var socket;

  SocketIO(this.socket) {
    initializeSocket();
  }

  void initializeSocket() {
    socket = io(
        'http://192.168.1.9:5000/',
        OptionBuilder().setTransports([
          "websocket",
        ]) // for Flutter or Dart VM
            .build());
    socket.onConnect((data) {
      print('connected');
    });
    print(socket);
  }
}
