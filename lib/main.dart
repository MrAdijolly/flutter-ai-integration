import 'package:flutter/material.dart';
import 'package:sn_project/cards.dart';
import 'package:sn_project/integrateAI.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SN_PROTOTYPE',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AIChatPage(),
    );
  }
} //blank right now,
