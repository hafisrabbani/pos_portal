import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';

bool _isSnackbarVisible = false;

enum SnackbarTheme { error, success, warning }

void showCustomSnackbar({
  required BuildContext context,
  required String title,
  required String message,
  required SnackbarTheme theme,
}) {
  if (_isSnackbarVisible) {
    return;
  }

  Color bgColor;
  Color iconColor;
  Icon icon;

  // Set colors and icon based on the theme
  switch (theme) {
    case SnackbarTheme.error:
      bgColor = MyColors.bgError;
      iconColor = MyColors.error;
      icon = Icon(Icons.priority_high_rounded, size: 12, color: bgColor);
      break;
    case SnackbarTheme.success:
      bgColor = MyColors.bgSuccess;
      iconColor = MyColors.success;
      icon = Icon(Icons.check, size: 12, color: bgColor);
      break;
    case SnackbarTheme.warning:
      bgColor = MyColors.bgWarning;
      iconColor = MyColors.warning;
      icon = Icon(Icons.close, size: 12, color: bgColor);
      break;
  }

  _isSnackbarVisible = true;

  final snackBar = SnackBar(
    duration: const Duration(seconds: 3),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: icon),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: TextButton(
        //     style: ButtonStyle(
        //       side: MaterialStateProperty.all(
        //           BorderSide(color: MyColors.primary)),
        //       shape: MaterialStateProperty.all(
        //         RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           side: BorderSide(color: MyColors.primary),
        //         ),
        //       ),
        //     ),
        //     onPressed: () {
        //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //       _isSnackbarVisible = false;
        //     },
        //     child: Text(
        //       'Tutup',
        //       style: TextStyle(
        //         color: MyColors.primary,
        //         fontFamily: 'Montserrat',
        //         fontWeight: FontWeight.w600,
        //         fontSize: 15,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    ),
    backgroundColor: bgColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    onVisible: () {
      _isSnackbarVisible = true;
    },
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((_) {
    _isSnackbarVisible = false;
  });
}
