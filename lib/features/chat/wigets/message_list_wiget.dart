import 'package:flutter/material.dart';
import 'package:krager/features/chat/wigets/message_context_menu_wiget.dart';
import 'package:krager/features/chat/wigets/message_wiget.dart';
import 'package:krager/repos/chat/models/message_model.dart';

class MessageListWiget extends StatefulWidget {
  const MessageListWiget({
    super.key,
    required this.message,
  });

  final Message message;
  
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _MessageListWidgetState(message: message);

}

class _MessageListWidgetState extends State<MessageListWiget>{

  final Message message;
  
  // ignore: constant_identifier_names
  static const Map<UserType, MainAxisAlignment> USER_MAIN_AXIS_ALIGNMENT = {
    UserType.currentUser: MainAxisAlignment.end,
    UserType.elseUser: MainAxisAlignment.start,
    UserType.systemMessage: MainAxisAlignment.center
  };  

  // ignore: constant_identifier_names
  static const Map<UserType, Alignment> USER_ALIGNMENT = {
    UserType.currentUser: Alignment.centerLeft,
    UserType.elseUser: Alignment.centerRight,
    UserType.systemMessage: Alignment.center
  };

  _MessageListWidgetState({required this.message});

  Widget contextMenu = Container();
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){
        contextMenu = MessageContextMenuWiget(message: message);
        setState(() {});
        Future.delayed(const Duration(seconds: 2));
        //contextMenu = Container();
        setState(() {});
      },
      onTap: () {
        if (contextMenu is MessageContextMenuWiget){
          contextMenu = Container();
          setState(() {});
        }
      },
      child: ListTile(
        title: Row(
          mainAxisAlignment: USER_MAIN_AXIS_ALIGNMENT[message.userType]!,
          children: [MessageWidget(message: message)],
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
        subtitle: Align(
          alignment: USER_ALIGNMENT[message.userType]!,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: contextMenu,
          )
        )
      ),
    );
  }
}