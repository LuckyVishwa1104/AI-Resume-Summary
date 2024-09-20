import 'package:ai_summary/main.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Summary'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await Amplify.Auth.signOut();
              // Navigate back to the sign-in screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            } catch (e) {
              safePrint('Error signing out: $e');
            }
          },
          child: const Text("Sign Out"),
        ),
      ),
    );
  }
}
