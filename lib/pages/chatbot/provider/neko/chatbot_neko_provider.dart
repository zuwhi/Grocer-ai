import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/model/chatbot/neko_model.dart';
import 'package:green_cart_scanner/service/chatbot/neko/neko_ai_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chatbot_neko_provider.g.dart';

@Riverpod(keepAlive: true)
class ChatBotNekoNotifier extends _$ChatBotNekoNotifier {
  @override
  List<ChatMessage> build() => [];
  final nekoService = NekoAIService();
  ChatUser nekoUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage:
        "https://logowik.com/content/uploads/images/google-ai-gemini91216.logowik.com.webp",
  );

  sendMessage(ChatMessage chatMessage) async {
    state = [chatMessage, ...state];

    Either<String, NekoModel> result =
        await nekoService.sendRequest(text: chatMessage.text);

    result.fold((l) => l, (r) {
      Logger().d(r.response);
      ChatMessage message = ChatMessage(
        user: nekoUser,
        createdAt: DateTime.now(),
        text: r.response ?? "",
      );

      state = [message, ...state];
    });
  }
}
