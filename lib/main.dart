import 'package:ai_summary/pages/chat_page.dart';
import 'package:ai_summary/pages/home_page.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'amplifyconfiguration.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);
      await Amplify.configure(amplifyconfig);

      await _checkUserSession();
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  Future<void> _checkUserSession() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      safePrint('Current state $user');
    } on AuthException catch (e) {
      safePrint('User not signed in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      signUpForm: SignUpForm.custom(fields: [
        SignUpFormField.name(required: true),
        SignUpFormField.email(required: true),
        SignUpFormField.password(),
        SignUpFormField.passwordConfirmation()
      ]),
      initialStep: AuthenticatorStep.signIn,
      child: MaterialApp(
        builder: Authenticator.builder(),
        debugShowCheckedModeBanner: false,
        home: ResumeForm(), // Navigate based on session
      ),
    );
  }
}
