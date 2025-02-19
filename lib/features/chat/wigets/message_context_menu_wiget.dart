import 'package:flutter/material.dart';
import 'package:krager/repos/chat/models/message_model.dart';

class MessageContextMenuWiget extends StatelessWidget{

  final Message message;

  const MessageContextMenuWiget({super.key, required this.message});

  static const List<Widget> actions = [
    Text("Reply"),
    Text("Copy"),
    Text("Forward"),
    Text("Select"),
    Text("Delete")
  ];

  List<Widget> interleaveDividers(List<Widget> widgets) {
    List<Widget> interleaved = [];
    for (int i = 0; i < widgets.length; i++) {
      interleaved.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                widgets[i],
                Container(
                  height: 1.5, 
                  color: i < widgets.length - 1 ? const Color.fromARGB(255, 180, 180, 180) : null, 
                  width: 170,)
              ],
            )
          ]
        )
      );
    }
    return interleaved;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 40
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).dialogBackgroundColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: interleaveDividers(actions),
      ),
    );
  }

}