import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/pages/chatbot/provider/gemini/chatbot_gemini_provider.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';
import 'package:green_cart_scanner/widgets/custom_textformfield_grey_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

class ChatBotGeminiPage extends ConsumerStatefulWidget {
  const ChatBotGeminiPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatBotGeminiPageState();
}

class _ChatBotGeminiPageState extends ConsumerState<ChatBotGeminiPage> {
  final ImagePicker _picker = ImagePicker();

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
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
          actions: [
            IconButton(
                onPressed: () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    title: "Hapus Chat",
                    text: 'Anda yakin ingin menghapus chat ini ?',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    confirmBtnColor: AppColor.primary,
                    onConfirmBtnTap: () {
                      ref
                          .watch(chatBotGeminiNotifierProvider.notifier)
                          .clearChat();
                      Navigator.pop(context);
                    },
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 2.0,
            ),
          ],
          backgroundColor: AppColor.primary,
          centerTitle: true,
          title: const Text(
            "AI Chat",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: DashChat(
          messageOptions: const MessageOptions(
            currentUserContainerColor: AppColor.primary,
            currentUserTextColor: Colors.white,
          ),
          inputOptions: InputOptions(
              cursorStyle: const CursorStyle(color: AppColor.primary),
              trailing: [
                IconButton(
                  onPressed: () {
                    showPickImage();
                  },
                  icon: const Icon(
                    Icons.image,
                    // color: AppColor.primary,
                  ),
                )
              ]),
          currentUser: currentUser,
          onSend: (message) => ref
              .watch(chatBotGeminiNotifierProvider.notifier)
              .sendMessage(message),
          messages: ref.watch(chatBotGeminiNotifierProvider),
        ));
  }

  showPickImage() async {
    TextEditingController pesanController = TextEditingController();
    final XFile? imagePick =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imagePick != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: Colors.white,
            actions: <Widget>[
              const SizedBox(
                height: 25.0,
              ),
              Center(
                child: Container(
                  color: Colors.amber,
                  margin: const EdgeInsets.all(0),
                  width: 200,
                  height: 200,
                  child: Image.file(
                    File(
                      imagePick.path,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              CustomTextFormFieldGrey(
                prefixIcon: Icons.chat_rounded,
                hintText: "tulis keterangan...",
                name: "",
                controller: pesanController,
              ),
              ButtonFullWidth(
                title: "kirim",
                onPressed: () async {
                  ChatMessage chatMessage = ChatMessage(
                    user: currentUser,
                    createdAt: DateTime.now(),
                    text: pesanController.text,
                    medias: [
                      ChatMedia(
                        url: imagePick.path,
                        fileName: "",
                        type: MediaType.image,
                      )
                    ],
                  );

                  ref
                      .watch(chatBotGeminiNotifierProvider.notifier)
                      .sendMessage(chatMessage);
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
  }
}
