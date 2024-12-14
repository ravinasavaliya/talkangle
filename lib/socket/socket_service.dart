import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketConnection {
  static IO.Socket? socket;

  static void connectSocket(Function onConnect) {
    socket = IO.io(
        'https://web.talkangels.com/', // new url
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect()
            .enableForceNew() // disable auto-connection
            .build());
    socket!.connect();
    socket!.onConnect((_) {
      log('ChatSocketManager connected');
      onConnect();
    });

    socket?.onConnecting((data) => debugPrint("ChatSocketManager onConnecting $data"));
    socket?.onConnectError((data) => debugPrint("ChatSocketManager onConnectError $data"));
    socket?.onError((data) => debugPrint("ChatSocketManager onError $data"));
    socket?.onDisconnect((data) => debugPrint("ChatSocketManager onDisconnect $data"));
  }

  static void socketDisconnect() {
    socket?.onDisconnect((data) => debugPrint("ChatSocketManager onDisconnect $data"));
  }
}
