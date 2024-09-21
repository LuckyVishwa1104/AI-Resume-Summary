import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final String apiKey = dotenv.env['GOOGLE_API_KEY']!;
  Future<String> generateIntroduction(String resumeData) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
    final prompt = "Here is my resume: $resumeData. Can you generate a personalized self-introduction?";

    final response = await model.generateContent([Content.text(prompt)]);
    return response.text!;
  }
}
