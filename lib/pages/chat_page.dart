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

  Future<void> _signOut() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Generate Introduction',
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: "Logout",
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _resumeController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Paste Your Resume Content Here',
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color
                        foregroundColor: Colors.white, // Text color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15), // Padding
                        textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400), // Text style
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        elevation: 2, // Shadow effect
                      ),
                      onPressed: _generateIntroduction,
                      child: Text('Generate Introduction'),
                    ),
              const SizedBox(height: 20),
              const Text(
                'Generated Self-Introduction:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_generatedIntroduction),
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
