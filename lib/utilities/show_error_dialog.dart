import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  // NOTE by leaving this String as type text, you can insert whatever text you need at that time as seen on the login view
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('An error occurred'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}
