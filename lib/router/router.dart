import 'package:krager/features/chat/view/chat_screen.dart';
import 'package:krager/features/chat_list/view/list_screen.dart';

final routes = {
        '/' : (context) => const MyHomePage(title: "krager"),
        '/chat' : (context) => const ChatScreen(),
      };