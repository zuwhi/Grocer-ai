// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/pages/chatbot/screen/chatbot_gemini_page.dart';
import 'package:green_cart_scanner/pages/chatbot/screen/chatbot_neko_page.dart';
import 'package:green_cart_scanner/pages/other/other_page.dart';

class ChatBotMenu extends ConsumerWidget {
  const ChatBotMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot"),
        centerTitle: true,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              CardButtonData(
                  page: const ChatBotGeminiPage(), title: "Chatbot Gemini AI"),
              CardButtonData(
                  page: const ChatBotCSNekoPage(), title: "Chatbot CS Neko"),
            ],
          ),
        ),
      ),
    );
  }
}
