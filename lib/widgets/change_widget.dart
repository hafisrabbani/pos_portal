import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/utils/helpers.dart';

class ChangeWidget extends StatelessWidget {
  const ChangeWidget({
    super.key,
    required this.change,
    required this.totalTransaction,
  });

  final int totalTransaction;
  final int? change;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.neutral),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Total Pesanan',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Rp ${formatRupiah(totalTransaction)}',
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: 1,
              child: Container(
                color: MyColors.neutral,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Uang Kembalian',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Rp ${formatRupiah((change ?? 0))}',
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        color: MyColors.onSecondary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}