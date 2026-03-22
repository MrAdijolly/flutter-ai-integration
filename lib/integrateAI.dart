import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sn_project/topbar.dart';
import 'api_key.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController controller = TextEditingController();

  String aiResponse = "";
  bool isLoading = false;

  File? selectedImage; // <-- moved to state (outside build)

  String cleanText(String text) {
    var result = text;

    // 1. Markdown headings: "# Title"
    result = result.replaceAllMapped(
      RegExp(r'^(#+)\s*(.+)$', multiLine: true),
      (m) {
        final title = m.group(2)!.toUpperCase();
        final underline = '━' * title.length;
        return '\n$title\n$underline\n\n';
      },
    );

    // 2. ALL CAPS headings: "RELATED CONCEPTS:"
    result = result.replaceAllMapped(
      RegExp(r'^([A-Z\s]+:)$', multiLine: true),
      (m) {
        final rawTitle = m.group(1)!;
        final title = rawTitle.replaceAll(':', '').trim();
        final underline = '━' * title.length;

        return '\n$title\n$underline\n\n';
      },
    );

    // 3. Bullets: "- item" or "* item"
    result = result.replaceAllMapped(
      RegExp(r'^[\-\*]\s+(.+)$', multiLine: true),
      (m) => '• ${m.group(1)!.trim()}',
    );

    // 4. Numbered lists: "1. item"
    result = result.replaceAllMapped(
      RegExp(r'^\d+\.\s+(.+)$', multiLine: true),
      (m) => '→ ${m.group(1)!.trim()}',
    );

    // 5. Bold: **text**
    result = result.replaceAllMapped(
      RegExp(r'\*\*(.+?)\*\*', dotAll: true),
      (m) => m.group(1)!.toUpperCase(),
    );

    // 6. Italic: *text*
    result = result.replaceAllMapped(
      RegExp(r'(?<!\*)\*(?!\*)(.+?)(?<!\*)\*(?!\*)', dotAll: true),
      (m) => m.group(1)!,
    );

    // 7. Inline code: `code`
    result = result.replaceAllMapped(
      RegExp(r'`([^`]+)`'),
      (m) => '[${m.group(1)}]',
    );

    // 8. Add spacing after bullets
    result = result.replaceAllMapped(
      RegExp(r'(• .+)'),
      (m) => '${m.group(1)}\n',
    );

    // 9. Clean excessive blank lines
    result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return result.trim();
  }

  Future<void> sendToAI(String prompt) async {
    // Always add your fixed keyword / instruction here
    const fixedPrefix =
        'Use Tom T Joseph Structured smart noteto answer the given prompt and ensure to maintain the format correctly :  ';

    final fullPrompt = '$fixedPrefix$prompt';

    setState(() {
      isLoading = true;
      aiResponse = "";
    });

    try {
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$api',
      );
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json', 'x-goog-api-key': api},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": fullPrompt, // <-- use fullPrompt instead of prompt
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
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
    final theme = Theme.of(context);
    const primaryColor = Color(0xFF2196F3);

    return Scaffold(
      // MODERN APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0B0B0F),
        centerTitle: false,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Builder(
            builder: (context) => InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.menu_rounded, color: Colors.white),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Structured Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Toms College ',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: const [
                Icon(Icons.bolt_rounded, size: 18, color: Colors.amber),
                SizedBox(width: 6),
                Text('AI Chat', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),

      // MODERN DRAWER
      drawer: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: Drawer(
          backgroundColor: const Color(0xFF0C0C10),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drawer header with gradient and avatar
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Toms College ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Structured Notes',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Navigation',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),

                const SizedBox(height: 4),
                ListTile(
                  leading: const Icon(Icons.home_rounded, color: Colors.white),
                  title: const Text(
                    "Toms Family",
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Topbar()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.chat_bubble_rounded,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "AI Chat",
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AIChatPage(),
                      ),
                    );
                  },
                ),

                const Spacer(),

                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Colors.white60,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You are using the AI assistant for quick structured notes.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white60,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      backgroundColor: Colors.black,
      body: Container(
        color: const Color(0xFF0D0D0D),
        child: Column(
          children: [
            // IMAGE PREVIEW
            if (selectedImage != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade900,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(selectedImage!, height: 150),
                      ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                selectedImage = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // RESPONSE AREA
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      aiResponse.isEmpty ? "How can I help you?" : aiResponse,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(color: primaryColor),
              ),

            // INPUT BAR
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
              decoration: const BoxDecoration(
                color: Color(0xFF121212),
                boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
              ),
              child: Row(
                children: [
                  // IMAGE BUTTON
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.image_outlined,
                        color: Colors.white70,
                      ),
                      onPressed: pickImage,
                    ),
                  ),

                  const SizedBox(width: 8),

                  // INPUT FIELD
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: controller,
                        style: const TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) {
                          if (value.trim().isEmpty || isLoading) return;

                          sendToAI(value);
                          controller.clear();

                          setState(() {
                            selectedImage = null;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Ask anything...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // SEND BUTTON
                  Container(
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: isLoading
                          ? null
                          : () {
                              if (controller.text.trim().isEmpty) return;
                              sendToAI(controller.text);
                              controller.clear();

                              setState(() {
                                selectedImage = null;
                              });
                            },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
