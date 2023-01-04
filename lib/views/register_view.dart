import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:developer' as devtools show log;
import 'package:mynotes/consts/route.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            // ignore: prefer_const_constructors
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // NOTE using pushNamed instead of pushNamedandRemoveUntil always the user to use the back button. Also, this places the pages onto of one another rather than replacing completely
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamed(verifyEmailRoute);
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                // devtools.log('registering');
                // devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  // devtools.log('weak password');
                  await showErrorDialog(
                    context,
                    'Weak Password',
                  );
                } else if (e.code == 'email-already-in-use') {
                  await showErrorDialog(
                    context,
                    'Email already in use',
                  );
                  // devtools.log('email already in use');
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(
                    context,
                    'Invalid Email',
                  );
                } else {
                  await showErrorDialog(
                    context,
                    'Error ${e.code}',
                  );
                  // devtools.log('invalid email');
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already registered? Login here!'))
        ],
      ),
    );
  }
}
