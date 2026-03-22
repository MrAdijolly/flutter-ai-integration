import 'package:flutter/material.dart';
import 'cards.dart';
import 'integrateAI.dart';

class Topbar extends StatelessWidget {
  const Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Structured Notes : Toms College of Engineering'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Menu", style: TextStyle(color: Colors.white)),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Toms Family"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Topbar()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text("AI Chat"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AIChatPage()),
                );
              },
            ),
          ],
        ),
      ),

      backgroundColor: Colors.grey,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 250, child: card(context, "Arts & Science")),
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
