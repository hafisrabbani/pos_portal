import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_portal/utils/colors.dart';

class CardAction extends StatelessWidget {
  final bool isImport;
  final VoidCallback? onPressed;
  const CardAction({
    super.key,
    this.isImport = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      elevation: 0,
      color: MyColors.tertiary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isImport ? 'Import Excel' : '5 Mei - 11 Mei 2024',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: onPressed ?? () {},
              icon: SvgPicture.asset(
                isImport
                    ? 'assets/svg/icon_export.svg'
                    : 'assets/svg/icon_calendar.svg',
                width: 30,
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
