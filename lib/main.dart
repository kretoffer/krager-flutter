import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:krager/app.dart';
import 'package:krager/di.dart';
import 'package:krager/repos/connect/server.dart';
import 'package:krager/repos/tech/ecxeption.dart';
import 'package:talker_flutter/talker_flutter.dart';

final Uint8List staticKey = Uint8List.fromList([211, 24, 208, 166, 197, 215, 47, 9, 229, 1, 149, 17, 185, 168, 40, 0, 55, 199, 206, 244, 27, 198, 23, 195, 182, 98, 188, 222, 18, 91, 173, 48]);
final Uint8List iv = Uint8List.fromList([107, 131, 115, 105, 147, 29, 89, 36, 161, 105, 244, 184, 33, 108, 248, 254]);  

void main() {
  _initDependencies();
  try {
    runApp(const MyApp());
  } catch (e, st) {
    DI<Talker>().handle(e, st, 'Exception with');
    sendAutoReport(e, st);
  }
}

void _initDependencies(){
  final talker = TalkerFlutter.init();
  DI.registerSingleton<Talker>(talker);
  talker.good("Talker initializated");
  final Server server = Server(staticKey: staticKey, iv: iv);
  DI.registerSingleton<Server>(server);
}