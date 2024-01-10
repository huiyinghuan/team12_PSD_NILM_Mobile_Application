import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String errorText;

  const ErrorDialog({
    super.key,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      content: Text(errorText),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
