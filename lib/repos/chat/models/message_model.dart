enum MessageType {
  text,
  image,
  video,
  emoji,
  mediaGroup,
  voiceMessage,
  videoMessage,
}

enum UserType {
  currentUser,
  elseUser,
  systemMessage
}

class Message{
  final MessageType type;
  final String version;
  final String text;
  final UserType userType;
  final String senderID;
  final String senderName;
  final int time;

  Message({required this.type, required this.version, required this.text, required this.userType, required this.senderID, required this.senderName, required this.time});
}