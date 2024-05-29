import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_portal/utils/colors.dart';

AppBar topBar(
    {required BuildContext context,
    required String title,
    bool isNeedActions = false,
    bool popTilDrop = false,
    bool isCanBack = false}) {
  return AppBar(
    centerTitle: true,
    leading: isCanBack
        ? IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 24,
              color: MyColors.primary,
            ),
            onPressed: () {
              if (popTilDrop) {
                Navigator.of(context).popUntil(ModalRoute.withName("/"));
              } else {
                Navigator.of(context).pop();
              }
            },
          )
        : null,
    title: Text(
      title,
      style: const TextStyle(
          fontFamily: 'Montserrat', fontSize: 17, fontWeight: FontWeight.w600),
    ),
    actions: [
      isNeedActions
          ? Transform.translate(
              offset: const Offset(-10, 0),
              child: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset('assets/svg/icon_export.svg')),
            )
          : const SizedBox(),
    ],
  );
}
