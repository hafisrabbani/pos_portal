import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pos_portal/routes/route_name.dart';
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
  @override
  void initState() {
    super.initState();
    _loadInfoProduct();
  }

  void _loadInfoProduct() async {
    // _infoProduct = await _productController.getInfoProduct();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardWallet(),
                CardInfo(),
                CardMenu(infoProduct: [1,1,1]),
                SegmentedControl(),
                GestureDetector(
                  onTap: () {
                    // PersistentNavBarNavigator.pushNewScreen(
                    //   context,
                    //   screen: StatsPage(),
                    //   withNavBar: true,
                    //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    // );
                  },
                  child: LineChart(),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingButtonDefault(
          heroTag: "home",
          title: 'Tambah Transaksi',
          // actionPressed: () => PersistentNavBarNavigator.pushNewScreen(
          //   context,
          //   screen: NewTransactionPage(),
          //   withNavBar: false,
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // ),
          actionPressed: () => {
            Navigator.pushNamed(context, RoutesName.newTransaction)
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}