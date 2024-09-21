import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatGPTService {
  final String apiKey = dotenv.env['API_KEY']!;

  Future<String> generateIntroduction(String resumeData) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'model': 'gpt-3.5-turbo', // or 'gpt-3.5-turbo'
      'messages': [
        {
          "role": "system",
          "content":
              "You are an assistant that generates professional introductions based on resumes."
        },
        {
          "role": "user",
          "content":
              "Here is my resume: $resumeData. Can you generate a personalized self-introduction?"
        }
      ],
      'max_tokens': 150, // Adjust the length as necessary
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print(jsonEncode(response.body));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['choices'][0]['message']['content'];
        return message;
      } else {
        throw Exception('Failed to connect to OpenAI API');
      }
    } catch (error) {
      return 'Error: $error';
    }
  }
}
