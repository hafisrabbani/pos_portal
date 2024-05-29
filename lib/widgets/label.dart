import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';

class Label extends StatelessWidget {
  const Label({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: RichText(
            text: TextSpan(
              text: 'Kode QR ini akan kadaluarsa dalam ',
              style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Montserrat',
                  color: MyColors.warning),
              children: const <TextSpan>[
                TextSpan(
                    text: '05.00',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        )
      ],
    );
  }
}
