import 'dart:math';

import 'package:krager/repos/chat/models/message_model.dart';

class ChatRepository{
  Future<List<Message>> getMessagesList() async{
    List<Message> messages = [];
    var random = Random();
    var values = UserType.values;
    for (var i = 0; i < 200; i++){
      var randomValue = values[random.nextInt(2)];
      messages.add(
        Message(type: MessageType.text, version: "0.0.1", text: "Hello world $i it is a very very biiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiig message", userType: randomValue,
          senderID: randomValue == UserType.currentUser ? "kretoffi": "userIDDD",
          senderName: randomValue == UserType.currentUser ? "KRETOFF": "NoName",
          time: DateTime(2028, 5, 8, 10, 57, 8).millisecondsSinceEpoch
        )
      );
    }
    return messages;
  }
}