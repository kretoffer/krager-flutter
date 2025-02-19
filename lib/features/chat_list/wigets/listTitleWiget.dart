import 'package:flutter/material.dart';
import 'package:krager/repos/chats/models/chat_model.dart';

class ListTileWiget extends StatelessWidget {
  const ListTileWiget({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(chat.iconURL, width: 100, height: 80,),
      title: Text(chat.name, style: Theme.of(context).textTheme.bodyLarge,),
      subtitle: Text('${chat.lastMessage}'),
      trailing: const Icon(Icons.arrow_forward_ios,),
      onTap: () {
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoinScreen())); Второй вариант, длинный
        Navigator.of(context).pushNamed
        (
          '/chat', arguments: {
            "chat": chat,
          }
        );
      },
    );
  }
}