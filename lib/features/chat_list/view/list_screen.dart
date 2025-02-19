import 'package:flutter/material.dart';
import 'package:krager/features/chat_list/wigets/listTitleWiget.dart';
import 'package:krager/repos/chats/chats_repo.dart';
import 'package:krager/repos/chats/models/chat_model.dart';

import '../wigets/wigets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Chat>? list; 

  @override
  void initState(){
    loadCoins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (list == null)
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
        padding: const EdgeInsets.only(top: 25),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: list!.length,
        itemBuilder: (context, i)  
        {
          final chat = list![i];
          return ListTileWiget(chat: chat);
        },
      )
    );
  }

  Future<void> loadCoins() async {
    list = await ChatsReposirory().getChatsList();
    setState(() {});
  }
}