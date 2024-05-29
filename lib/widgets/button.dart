import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_portal/utils/colors.dart';

class ButtonDefault extends StatelessWidget {
  final String title;
  final bool isFilled;
  final bool isNeedSvg;
  final bool isDisabled;
  String? svgPath;
  final VoidCallback onPressed;

  ButtonDefault({
    super.key,
    required this.title,
    this.isFilled = false,
    required this.onPressed,
    this.isNeedSvg = false,
    this.svgPath,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        elevation: MaterialStateProperty.all<double>(0),
        backgroundColor: MaterialStateProperty.all<Color>(isFilled
            ? (isDisabled ? MyColors.neutral : MyColors.primary)
            : Colors.white),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isFilled
                ? const BorderSide(style: BorderStyle.none)
                : const BorderSide(color: MyColors.primary, width: 1.5),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isNeedSvg
              ? Container(
                  margin: EdgeInsets.only(right: 4),
                  child: AspectRatio(
                    aspectRatio: 0.25,
                    child: SvgPicture.asset(svgPath ?? ''),
                  ),
                )
              : SizedBox(), // Add this line
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: isFilled ? Colors.white : MyColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
