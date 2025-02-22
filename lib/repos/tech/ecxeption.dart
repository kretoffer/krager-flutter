import 'package:krager/di.dart';
import 'package:talker_flutter/talker_flutter.dart';

void sendAutoReport(e, st, {String? log}){
  Map<String, String> report = {
    "exeption": e.toString(),
    "StackTrace": st.toString(),
    "log": log ?? DI<Talker>().history.flutterText
  };
}