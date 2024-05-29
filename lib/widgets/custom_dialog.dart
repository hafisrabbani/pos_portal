import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomConfirmationDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: MyColors.secondaryDisabled,
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
