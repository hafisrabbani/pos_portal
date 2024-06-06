import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pos_portal/utils/colors.dart';

class FloatingButtonDefault extends StatelessWidget {
  final String title;
  final bool isFilled;
  final bool isDisabled;
  final bool isTransparent;
  final bool isOutlineTransparent;
  final Color? customColor;
  final VoidCallback actionPressed;
  final String heroTag;

  FloatingButtonDefault({
    super.key,
    this.isFilled = false, // Tetapkan nilai default di sini
    required this.title,
    required this.actionPressed,
    required this.heroTag,
    this.isDisabled = false,
    this.isTransparent = false,
    this.isOutlineTransparent = false,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: actionPressed,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width - 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isFilled
                  ? (isTransparent
                      ? Colors.transparent
                      : (isDisabled ? MyColors.neutral : MyColors.primary))
                  : Colors.white,
              border: Border.all(
                color: isOutlineTransparent
                    ? Colors.transparent
                    : (isFilled
                        ? isTransparent
                            ? Colors.white
                            : Colors.transparent
                        : MyColors.primary),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: customColor ??
                      (isFilled ? Colors.white : MyColors.primary),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
