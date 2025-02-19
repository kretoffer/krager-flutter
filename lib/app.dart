import 'package:krager/router/router.dart';
import 'package:krager/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themes,
      routes: routes,
      initialRoute: "/",
    );
  }
}