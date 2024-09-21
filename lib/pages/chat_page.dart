import 'package:ai_summary/services/chatgpt_service.dart';
import 'package:flutter/material.dart';


class ResumeForm extends StatefulWidget {
  @override
  _ResumeFormState createState() => _ResumeFormState();
}

class _ResumeFormState extends State<ResumeForm> {
  final _resumeController = TextEditingController();
  final ChatGPTService _chatGPTService = ChatGPTService();

  String _generatedIntroduction = '';
  bool _isLoading = false;

  void _generateIntroduction() async {
    setState(() {
      _isLoading = true;
    });

    final resumeText = _resumeController.text;
    final introduction = await _chatGPTService.generateIntroduction(resumeText);

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
        child: Column(
          children: [
            TextField(
              controller: _resumeController,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Paste Your Resume Here',
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _generateIntroduction,
                    child: Text('Generate Introduction'),
                  ),
            SizedBox(height: 20),
            Text(
              'Generated Self-Introduction:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(_generatedIntroduction),
          ],
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