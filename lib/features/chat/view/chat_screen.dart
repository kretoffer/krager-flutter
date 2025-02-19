import 'package:flutter/material.dart';
import 'package:krager/features/chat/wigets/message_list_wiget.dart';
import 'package:krager/repos/chat/chat_repo.dart';
import 'package:krager/repos/chat/models/message_model.dart';
import 'package:krager/repos/chats/models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{
  Chat? chat;
  List<Message>? messages;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null && args is Map<String, dynamic>);
    if (args == null || args is !Map){
      return;
    }

    chat = args["chat"];
    super.didChangeDependencies();
  }

  @override
  void initState(){
    loadMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chat!.name),
      ),
      body: (messages == null)
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
        padding: const EdgeInsets.only(top: 10),
        separatorBuilder: (context, index) => Container(height: 0,),
        itemCount: messages!.length,
        itemBuilder: (context, i)  
        {
          final message = messages![i];
          return MessageListWiget(message: message);
        },
      ),
      backgroundColor: const Color.fromARGB(255, 89, 89, 89),
    );
  }

  Future<void> loadMessages() async {
    messages = await ChatRepository().getMessagesList();
    setState(() {});
  }
}