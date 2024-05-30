import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/view_model/homepage_view_model.dart';
import 'package:pos_portal/widgets/floating_button.dart';
import 'package:pos_portal/widgets/card_info.dart';
import 'package:pos_portal/widgets/card_menu.dart';
import 'package:pos_portal/widgets/card_wallet.dart';
import 'package:pos_portal/widgets/line_chart.dart';
import 'package:pos_portal/widgets/segmented_control.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomepageViewModel homepageViewModel = HomepageViewModel();
  List<int> _infoProduct = [0,0,0];
  String _omzet = '0';
  int _selectedSegment = 1;
  @override
  void initState() {
    super.initState();
    _loadInfoProduct();
    getOmzet();
  }

  void getOmzet() async {
    final omzet = await homepageViewModel.getOmsetToday();
    setState(() {
      _omzet = omzet;
    });
  }

  void _loadInfoProduct() async {
    final infoProduct = await homepageViewModel.getTransactionCount();
    setState(() {
      _infoProduct = infoProduct;
    });
  }

  void _onSegmentChanged(int value) {
    setState(() {
      _selectedSegment = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardWallet(),
                CardInfo(),
                CardMenu(infoProduct: _infoProduct),
                SegmentedControl(onValueChanged: _onSegmentChanged),
                GestureDetector(
                  onTap: () {},
                  child: SingleChildScrollView(
                      child: LineChartWidget(
                    selectedSegment: _selectedSegment,
                  )),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingButtonDefault(
          heroTag: "home",
          title: 'Tambah Transaksi',
          actionPressed: () =>
              {Navigator.pushNamed(context, RoutesName.newTransaction)},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
