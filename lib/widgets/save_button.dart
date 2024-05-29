import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';

class ButtonSave extends StatelessWidget {
  final String title;
  final bool isFilled;

  ButtonSave({
    super.key,
    this.isFilled = false, // Tetapkan nilai default di sini
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FloatingActionButton.extended(
              elevation: 0,
              backgroundColor: isFilled ? MyColors.primary : MyColors.secondaryDisabled,
              onPressed: () {},
              label: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: isFilled ? Colors.white : MyColors.secondaryDisabled,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8), // Sesuaikan degan kebutuhan
                side: isFilled
                    ? const BorderSide(style: BorderStyle.none)
                    : const BorderSide(
                        color: MyColors.primary, width: 1.5), // Warna border
              ),
            ),
          ),
        ),
      ],
    );
  }
}
