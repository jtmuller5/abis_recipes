import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:abis_recipes/features/books/models/gpt_message.dart';
import 'package:flutter/foundation.dart';

class ChatGptService{
  static Future<GptMessage> shortenContent(String text) async {
    String apiKey=const String.fromEnvironment('chat_key');
    http.Response response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $apiKey",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": "Shorten this '$text'"}
        ]
      }),
    );

    debugPrint("Response status: ${response.statusCode}");
    debugPrint("Response body: ${response.body}");

    GptMessage gptMessage = GptMessage.fromJson(jsonDecode(response.body));

    return gptMessage;
  }
}