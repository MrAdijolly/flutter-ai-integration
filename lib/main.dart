import 'package:flutter/material.dart';
import 'package:sn_project/semester.dart';
//import 'package:sn_project/cards.dart';

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
      home: const Topbar(), //blank right now,
    );
  }
}

class Topbar extends StatelessWidget {
  const Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stuctured Notes : Toms College of engineering'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 250, child: card(context, " Arts & Science")),
            const SizedBox(height: 20),

            SizedBox(width: 250, child: card(context, "Polytechnic")),
            const SizedBox(height: 20),

            SizedBox(width: 250, child: card(context, "Engineering : BTECH")),
          ],
        ),
      ),
    );
  }
}

Widget card(BuildContext context, String text) {
  Widget page;
  if (text == "Engineering : BTECH") {
    page = Btech_Selectables(title: text);
  } else {
    page = Selectables(title: text);
  }
  return Card(
    child: InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Center(child: Text(text, style: const TextStyle(fontSize: 18))),
    ),
  );
}
