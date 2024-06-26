// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:green_cart_scanner/constant/appColor.dart';

class TextFormQuill extends StatelessWidget {
  final QuillController controller;
  const TextFormQuill({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillProvider(
          configurations: QuillConfigurations(
            controller: controller,
            sharedConfigurations: const QuillSharedConfigurations(
              locale: Locale('id', 'ID'),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const QuillToolbar(
                  configurations: QuillToolbarConfigurations(
                    showAlignmentButtons: false,
                    // showColorButton: false,
                    showBackgroundColorButton: false,
                    showCodeBlock: false,
                    showHeaderStyle: false,
                    // showDirection: false,
                    // showListBullets: false,
                    showFontFamily: false,
                    showSearchButton: false,
                    // showLink: false,
                    showListCheck: false,
                    showDividers: false,
                    // showListNumbers: false,
                    showSuperscript: false,
                    showClearFormat: false,
                    showQuote: false,
                    showUnderLineButton: false,
                    showIndent: false,
                    showStrikeThrough: false,
                    showSubscript: false,
                    showInlineCode: false,
                    // showFontSize: false
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: AppColor.grey6,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: QuillEditor.basic(
                  configurations: const QuillEditorConfigurations(
                    readOnly: false,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
