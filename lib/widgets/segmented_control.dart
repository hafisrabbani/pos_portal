import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';

class SegmentedControl extends StatelessWidget {
  const SegmentedControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSlidingSegmentedControl<int>(
      innerPadding: EdgeInsets.all(8),
      isStretch: true,
      initialValue: 1,
      children: const {
        1: Text('Minggu',
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
        2: Text('Bulan',
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
        3: Text('Tahun',
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
      },
      decoration: BoxDecoration(
        color: MyColors.tertiary,
        borderRadius: BorderRadius.circular(12),
      ),
      thumbDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 4.0,
            offset: Offset(
              0.0,
              2.0,
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      onValueChanged: (v) {
        print(v);
      },
    );
  }
}
