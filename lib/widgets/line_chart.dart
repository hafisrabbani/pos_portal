import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_portal/data/type/chart_type.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/utils/helpers.dart';
import 'package:pos_portal/view_model/homepage_view_model.dart';

class LineChartWidget extends StatefulWidget {
  final int selectedSegment;

  const LineChartWidget({
    super.key,
    required this.selectedSegment,
  });

  List<String> get harian =>
      const ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

  List<String> get bulanan => const [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  final HomepageViewModel homepageViewModel = HomepageViewModel();
  List<FlSpot> statistik = [];
  List<int> originalData = [];
  int maxData = 100;
  bool isLoading = true;

  void loadStatistik() async {
    var data = await homepageViewModel.getStatisticTrx(
        widget.selectedSegment == 1 ? ChartType.weekly : ChartType.monthly);

    setState(() {
      originalData = data;
      maxData = getMaxValue(data);
      statistik = List<FlSpot>.from(data
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())));
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadStatistik();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: MyColors.primary,
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Container(
              height: 250,
              child: LineChart(LineChartData(
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: widget.selectedSegment == 1
                          ? titleHarian
                          : titleBulanan,
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 42,
                      interval: 1,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                minX: 0,
                maxX: (widget.selectedSegment == 1)
                    ? widget.harian.length.toDouble() - 1
                    : widget.bulanan.length.toDouble() - 1,
                minY: 0,
                maxY: maxData.toDouble(),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: false,
                ),
                lineTouchData: LineTouchData(
                  touchSpotThreshold: 30,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.white,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;

                        TextAlign textAlign;
                        switch (flSpot.x.toInt()) {
                          case 1:
                            textAlign = TextAlign.left;
                            break;
                          case 5:
                            textAlign = TextAlign.right;
                            break;
                          default:
                            textAlign = TextAlign.center;
                        }

                        return LineTooltipItem(
                          '${flSpot.y.toInt().toString()} \n',
                          const TextStyle(
                              color: MyColors.primary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                          children: [
                            TextSpan(
                              text: (widget.selectedSegment == 1)
                                  ? widget.harian[flSpot.x.toInt()]
                                  : widget.bulanan[flSpot.x.toInt()],
                              style: const TextStyle(
                                  color: MyColors.primary,
                                  fontSize: 11,
                                  fontFamily: 'Montserrat'),
                            ),
                          ],
                          textAlign: textAlign,
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: statistik,
                    isCurved: true,
                    color: MyColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              MyColors.primary.withOpacity(0.3),
                              MyColors.primary.withOpacity(0)
                            ])),
                    dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                                radius: 4,
                                color: MyColors.primary,
                                strokeWidth: 3,
                                strokeColor: Colors.white)),
                  ),
                ],
              )),
            ),
          );
  }
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 11,
    color: MyColors.neutral,
  );
  String text;
  if (value.toInt() == 0) {
    text = '0';
  } else if (value.toInt() % 50 == 0) {
    text = value.toInt().toString();
  } else {
    text = '';
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}

Widget titleHarian(double value, TitleMeta meta) {
  const style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 11,
    color: MyColors.neutral,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('Sen', style: style);
      break;
    case 1:
      text = const Text('Sel', style: style);
      break;
    case 2:
      text = const Text('Rab', style: style);
      break;
    case 3:
      text = const Text('Kam', style: style);
      break;
    case 4:
      text = const Text('Jum', style: style);
      break;
    case 5:
      text = const Text('Sab', style: style);
      break;
    case 6:
      text = const Text('Min', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget titleBulanan(double value, TitleMeta meta) {
  const style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 11,
    color: MyColors.neutral,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('Jan', style: style);
      break;
    case 1:
      text = const Text('Feb', style: style);
      break;
    case 2:
      text = const Text('Mar', style: style);
      break;
    case 3:
      text = const Text('Apr', style: style);
      break;
    case 4:
      text = const Text('Mei', style: style);
      break;
    case 5:
      text = const Text('Jun', style: style);
      break;
    case 6:
      text = const Text('Jul', style: style);
      break;
    case 7:
      text = const Text('Agu', style: style);
      break;
    case 8:
      text = const Text('Sep', style: style);
      break;
    case 9:
      text = const Text('Okt', style: style);
      break;
    case 10:
      text = const Text('Nov', style: style);
      break;
    case 11:
      text = const Text('Des', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}
