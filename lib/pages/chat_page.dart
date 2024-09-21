import 'package:ai_summary/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:ai_summary/main.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class ResumeForm extends StatefulWidget {
  @override
  _ResumeFormState createState() => _ResumeFormState();
}

class _ResumeFormState extends State<ResumeForm> {
  final _resumeController = TextEditingController();
  // final ChatGPTService _chatGPTService = ChatGPTService();
  final GeminiService _geminiService = GeminiService();

  String _generatedIntroduction = '';
  bool _isLoading = false;

  void _generateIntroduction() async {
    setState(() {
      _isLoading = true;
    });

    final resumeText = _resumeController.text;
    final introduction = await _geminiService.generateIntroduction(resumeText);

    setState(() {
      _generatedIntroduction = introduction;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate Introduction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _resumeController,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Paste Your Resume Here',
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _generateIntroduction,
                      child: const Text('Generate Introduction'),
                    ),
              const SizedBox(height: 20),
              const Text(
                'Generated Self-Introduction:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_generatedIntroduction),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await Amplify.Auth.signOut();
                    // Navigate back to the sign-in screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  } catch (e) {
                    safePrint('Error signing out: $e');
                  }
                },
                child: const Text("Sign Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _resumeController.dispose();
    super.dispose();
  }
}
