// FIXME to enable firebase you must write the following lines in the terminal
// flutter pub add firebase_core
// flutter pub add firebase_auth
// flutter pub add cloud_firestore
// flutter pub add firebase_analytics
// npm instal -g firebase-tools
// firebase login and follow the link
// dart pub global active flutterfire_cli
// flutterfire configure
import 'package:flutter/material.dart';
import 'package:mynotes/consts/route.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_views.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'firebase_options.dart';
// NOTE using show only brings in a certain part of the import instead of the whole thing
// NOTE using 'as' alias out where log is coming from.
import 'dart:developer' as devtools show log;
// NOTE now to use log you must type devtools.log()

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      notesRoute: (context) => const NotesView()
    },
    // home: const LoginView(),
    // home: const RegisterView(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                devtools.log('email is verified');
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
