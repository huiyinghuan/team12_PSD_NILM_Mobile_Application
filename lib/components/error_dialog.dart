import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final String errorText;
  final String title;

  const DialogBox({
    super.key,
    required this.errorText,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(errorText),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
