import 'package:flutter/material.dart';
import 'package:sn_project/subjects.dart';

class Selectables extends StatelessWidget {
  final String title;
  const Selectables({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(10),
        children: [
          for (int i = 1; i <= 6; i++)
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Subject(title: "Semester $i"),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    "Semester $i",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Btech_Selectables extends StatelessWidget {
  final String title;
  const Btech_Selectables({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(10),
        children: [
          for (int i = 1; i <= 8; i++)
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Subject(title: "Semester $i"),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    "Semester $i",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
