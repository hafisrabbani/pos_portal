import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';

class TableBuilder extends StatelessWidget {
  const TableBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.secondaryDisabled,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: MyColors.primary, // Warna tepi card
            width: 1, // Lebar tepi card
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text (
              'Rp 100.000',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
