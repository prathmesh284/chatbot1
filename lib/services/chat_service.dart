import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/message_model.dart';

class ChatService {
  static Future<Message?> getReply(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'HTTP-Referer': 'https://yourapp.com',
          'X-Title': 'Flutter AI Chat',
        },
        body: jsonEncode({
          "model": "mistralai/mistral-7b-instruct",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": userMessage}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        return Message(role: "assistant", content: reply.trim());
      } else {
        return Message(role: "assistant", content: "⚠️ API Error: ${response.body}");
      }
    } catch (e) {
      return Message(role: "assistant", content: "⚠️ Error: $e");
    }
  }
}
