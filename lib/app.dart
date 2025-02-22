import 'package:krager/di.dart';
import 'package:krager/router/router.dart';
import 'package:krager/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krager',
      theme: themes,
      routes: routes,
      initialRoute: "/",
      navigatorObservers: [
        TalkerRouteObserver(DI<Talker>())
      ],
    );
  }
}