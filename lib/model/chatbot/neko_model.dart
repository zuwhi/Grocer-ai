// To parse this JSON data, do
//
//     final nekoModel = nekoModelFromJson(jsonString);

import 'dart:convert';

NekoModel nekoModelFromJson(String str) => NekoModel.fromJson(json.decode(str));

String nekoModelToJson(NekoModel data) => json.encode(data.toJson());

class NekoModel {
  final String? response;
  final String? sourceResponse;
  final String? input;
  final String? prompt;
  final String? model;
  final String? key;
  final int? status;
  final Headers? headers;

  NekoModel({
    this.response,
    this.sourceResponse,
    this.input,
    this.prompt,
    this.model,
    this.key,
    this.status,
    this.headers,
  });

  factory NekoModel.fromJson(Map<String, dynamic> json) => NekoModel(
        response: json["response"],
        sourceResponse: json["source_response"],
        input: json["input"],
        prompt: json["prompt"],
        model: json["model"],
        key: json["key"],
        status: json["status"],
        headers:
            json["headers"] == null ? null : Headers.fromJson(json["headers"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "source_response": sourceResponse,
        "input": input,
        "prompt": prompt,
        "model": model,
        "key": key,
        "status": status,
        "headers": headers?.toJson(),
      };
}

class Headers {
  Headers();

  factory Headers.fromJson(Map<String, dynamic> json) => Headers();

  Map<String, dynamic> toJson() => {};
}
