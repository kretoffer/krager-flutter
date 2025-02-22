// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:krager/di.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'crypto.dart';

class Server {
  late final Stream brStream;

  final StreamController<dynamic> _SocketController = StreamController<dynamic>();

  int stream_responce_count = 0;
  late final CryptoCipher cipher;
  late final Socket socket;
  bool conected = false;

  Server({required Uint8List staticKey, required Uint8List iv}){
    conected = false;
    connect(staticKey, iv);
  }

  //private
  Stream stream() async* {
    await for (var event in _SocketController.stream){
      yield event;
    }
  }
  void addEventToStream(dynamic event){
    _SocketController.add(event);
  }
  //

  void sendMessageToServer(Uint8List message){
    var encrypt_message = cipher.encrypt(message);
    socket.add(encrypt_message);
  }

  void connect(Uint8List staticKey, Uint8List iv) async {
    brStream = stream().asBroadcastStream();
    socket = await Socket.connect('127.0.0.1', 1255);
    DI<Talker>().info("Connect to: ${socket.remoteAddress.address}:${socket.remotePort}");

    cipher = CryptoCipher(staticKey: staticKey, iv: iv);

    final Map<String, dynamic> data_1 = {
      'type': 'connect',
      'publicKey': cipher.publicRsaKeyToBytes(cipher.my_public_RSA_key),
      'connectMode': 'd',
      'version': '0.0.1'
    };

    final Map<String, dynamic> data_2 = {
        "type": "connect",
        "userID": "kretoffi",
        "deviceID": 0
    };

    var data = jsonEncode(data_1);
    var bytes = utf8.encode(data);

    socket.add(bytes);
    await socket.flush();

    startListening(socket);

    while (stream_responce_count < 1) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    data = jsonEncode(data_2);
    bytes = utf8.encode(data);
    var encrypt_bytes = cipher.rsaEncrypt(bytes);

    socket.add(encrypt_bytes);
    await socket.flush();

    while (stream_responce_count < 2) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    var key = cipher.publicKeyToBytes(cipher.dh_public_key);
    var message = cipher.rsaPaesEncrypt(key);
    socket.add(message);
    await socket.flush();

    while (stream_responce_count < 3) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    conected = true;
    DI<Talker>().good("good connect to server");
  }

  void startListening(Socket socket) {
    socket.listen((List<int> data) {
      if (stream_responce_count == 0) {
        var a = Uint8List.fromList(data);
        var decrypt_data = cipher.rsaDecrypt(a);
        String response = utf8.decode(decrypt_data);

        Map<String, dynamic> jsonResponse = jsonDecode(response);
        cipher.client_public_RSA_key = cipher.pythonStringToPublicRsaKey(jsonResponse["key"]);
      } else if (stream_responce_count == 1) {
        var decypt_data = cipher.rsaPaesDecrypt(Uint8List.fromList(data));
        cipher.parameters = utf8.decode(decypt_data);
      } else if (stream_responce_count == 2) {
        var decrypt_data = cipher.rsaPaesDecrypt(Uint8List.fromList(data));
        cipher.server_dh_public_key = cipher.bytesToPublicKey(decrypt_data);
      } else {
        var decrypt_data = cipher.decrypt(Uint8List.fromList(data));
        addEventToStream(decrypt_data);
      }
      stream_responce_count++;
    }, onDone: () {
      // Переподключение при завершении соединения
      reconnect(socket);
    }, onError: (error) {
      // Обработка ошибок
      DI<Talker>().error(error);
      reconnect(socket);
    });
  }

  void reconnect(Socket socket) {
    // Логика переподключения
    DI<Talker>().warning('Lost connecr\nReconecting...');
    // Пример переподключения через 5 секунд
    Future.delayed(const Duration(seconds: 5), () {
      // Здесь нужно реализовать логику переподключения к серверу
      //TODO
      throw UnimplementedError();
    });
  }
}