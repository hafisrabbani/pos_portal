import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/utils/colors.dart';
// import 'package:pos_portal/pages/home/new_transaction_page.dart';
// import 'package:pos_portal/pages/home/stats_page.dart';
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
  List<int> _infoProduct = [];
  int _selectedSegment = 1;
  @override
  void initState() {
    super.initState();
    _loadInfoProduct();
  }

  void _loadInfoProduct() async {
    // _infoProduct = await _productController.getInfoProduct();
  }

  void _onSegmentChanged(int value) {
    setState(() {
      _selectedSegment = value;
    });
    // Do something with the new value
    print('Selected segment: $value');
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
                CardMenu(infoProduct: [1, 1, 1]),
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
