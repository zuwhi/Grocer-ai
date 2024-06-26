// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

// ignore: must_be_immutable
class ReadTextFormQuill extends StatelessWidget {
  final double? maxHeight;
  final String text;
  final double? sizeHeight;
  ReadTextFormQuill({
    super.key,
    required this.text,
    this.sizeHeight,
    this.maxHeight,
  });

  QuillController controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    final json = jsonDecode(text);

    controller.document = Document.fromJson(json);

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
            children: [
              SizedBox(
                height: sizeHeight,
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                      readOnly: true, showCursor: false, maxHeight: maxHeight),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
