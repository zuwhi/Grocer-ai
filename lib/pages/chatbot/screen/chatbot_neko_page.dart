import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/pages/chatbot/provider/neko/chatbot_neko_provider.dart';

class ChatBotCSNekoPage extends ConsumerStatefulWidget {
  const ChatBotCSNekoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatBotCSNekoPageState();
}

class _ChatBotCSNekoPageState extends ConsumerState<ChatBotCSNekoPage> {
  ChatUser currentUser = ChatUser(
    id: "0",
    firstName: "User",
  );

  ChatUser nekoAI = ChatUser(
      id: "1",
      firstName: "Neko AI",
      profileImage:
          "https://www.spaceneko.ai/_next/image?url=%2FSpaceNeko_Loge_trans.png&w=384&q=75");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColor.primary,
        centerTitle: true,
        title: const Text(
          "Neko AI Chat",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: DashChat(
        currentUser: currentUser,
        onSend: (message) => ref
            .watch(chatBotNekoNotifierProvider.notifier)
            .sendMessage(message),
        messages: ref.watch(chatBotNekoNotifierProvider),
      ),
    );
  }
}
