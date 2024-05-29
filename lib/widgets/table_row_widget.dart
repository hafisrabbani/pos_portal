import 'package:flutter/cupertino.dart';

Padding tableRowItem({required String title, bool isHeader = false}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: isHeader ? 12 : 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}