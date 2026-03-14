import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_key.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController controller = TextEditingController();

  String aiResponse = "";
  bool isLoading = false;

  String cleanText(String text) {
    return text
        .replaceAll(RegExp(r'\*\*'), '') // remove **
        .replaceAll(RegExp(r'\*'), '') // remove *
        .replaceAll(RegExp(r'#'), '') // remove #
        .replaceAll(RegExp(r'`'), '') // remove `
        .replaceAll(RegExp(r'- '), '') // remove -
        .trim();
  }

  Future<void> sendToAI(String prompt) async {
    setState(() {
      isLoading = true;
      aiResponse = "";
    });

    try {
      // 1) Replace with a real AI endpoint and key
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent',
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': api, // if needed
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 2) Adjust this line to match the API’s JSON shape
        final text =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
            'No response';
        setState(() {
          aiResponse = cleanText(text.toString());
        });
      } else {
        setState(() {
          aiResponse = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        aiResponse = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Structured Notes AI"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Ask something",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      sendToAI(controller.text);
                    },
              child: Text(isLoading ? "Loading..." : "Send"),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Text(aiResponse, style: const TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
