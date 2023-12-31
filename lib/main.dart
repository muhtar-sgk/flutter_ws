import 'package:flutter/material.dart';
import 'package:getz_pos/home_screen.dart';
import 'package:getz_pos/pusher_example_screen.dart';
import 'package:getz_pos/ws_example_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Socket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const PusherExampleScreen()
      home: const HomeScreen()
    );
  }
}
