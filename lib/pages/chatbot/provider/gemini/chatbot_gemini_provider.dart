import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chatbot_gemini_provider.g.dart';

@Riverpod(keepAlive: true)
class ChatBotGeminiNotifier extends _$ChatBotGeminiNotifier {
  @override
  List<ChatMessage> build() => [];

  final Gemini gemini = Gemini.instance;
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage:
        "https://logowik.com/content/uploads/images/google-ai-gemini91216.logowik.com.webp",
  );

  sendMessage(ChatMessage chatMessage) {
    state = [chatMessage, ...state];

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen((event) {
        ChatMessage? lastMessage = state.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = state.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;

          state = [lastMessage, ...state];
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );

          state = [message, ...state];
        }
      });
    } catch (e) {
      print(e);
    }
  }

  clearChat() {
    state = [];
  }
}
