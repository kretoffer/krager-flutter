import 'package:krager/di.dart';
import 'package:krager/features/chat/view/chat_screen.dart';
import 'package:krager/features/chat_list/view/list_screen.dart';
import 'package:talker_flutter/talker_flutter.dart';

final routes = {
        '/' : (context) => const MyHomePage(title: "krager"),
        '/chat' : (context) => const ChatScreen(),
        '/talker' : (context) => TalkerScreen(talker: DI<Talker>())
      };