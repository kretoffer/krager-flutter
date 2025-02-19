import 'package:flutter/material.dart';

final themes = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 34, 167, 255)),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          bodyMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 134, 134, 134)
          )
        ),
        dividerColor: Colors.amber,
        appBarTheme: const AppBarTheme(
          elevation: 5,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 30,
            color: Colors.black,
          ),
          
        )
      );