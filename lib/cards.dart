import 'package:flutter/material.dart';
import 'package:sn_project/semester.dart';

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
