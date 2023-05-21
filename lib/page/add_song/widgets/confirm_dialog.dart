import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function(bool)? onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Confirm'),
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!(true);
            }
          },
        ),
      ],
    );
  }
}
