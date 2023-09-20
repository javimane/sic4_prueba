import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';


// Replace with your client id
const googleClientId =
    '957127067434-fqm79i28lnuqtitbqdg73fqc6hnfjm90.apps.googleusercontent.com';

// Replace with your client id


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: _LoginPage(),
    );
  }
}



class _LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [
        GoogleProvider(clientId: googleClientId),
       
        EmailAuthProvider(),
      ],
    );
  }
}
