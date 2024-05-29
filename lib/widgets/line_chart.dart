import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Container(
        color: MyColors.neutral,
        height: 250,
      ),
    );
  }
}
