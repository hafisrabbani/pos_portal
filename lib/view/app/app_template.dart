import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_portal/view/new_product/product_pages.dart';
import 'package:pos_portal/view/setting/setting_page.dart';
import 'package:pos_portal/view_model/navigation_view_model.dart';
import 'package:pos_portal/view_model/navigation_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors.dart';
import '../home/home_page.dart';
import '../product/product_page.dart';
import '../transaction/transaction_page.dart';

class AppTemplate extends StatefulWidget {
  const AppTemplate({super.key});

  @override
  State<AppTemplate> createState() => _AppTemplateState();
}

class _AppTemplateState extends State<AppTemplate> {
  late NavigationViewModel _viewModel;

  static const listPage = <Widget>[
    HomePage(),
    NewProductPage(),
    TransactionPage(),
    SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = NavigationViewModel();
  }

  @override
  void dispose() {
    _viewModel.selectedIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _viewModel.selectedIndexNotifier,
      builder: (context, selectedIndex, child) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: listPage[selectedIndex],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (int index) {
              _viewModel.saveSelectedIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/navbar/home_outlined.svg',
                ),
                activeIcon: SvgPicture.asset(
                  'assets/navbar/home.svg',
                ),
                label: "Beranda",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/navbar/cart_outlined.svg',
                ),
                activeIcon: SvgPicture.asset(
                  'assets/navbar/cart.svg',
                ),
                label: "Produk",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/navbar/transaction_outlined.svg',
                ),
                activeIcon: SvgPicture.asset(
                  'assets/navbar/transaction.svg',
                ),
                label: "Transaksi",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/navbar/setting_outlined.svg',
                ),
                activeIcon: SvgPicture.asset(
                  'assets/navbar/setting.svg',
                ),
                label: "Pengaturan",
                backgroundColor: Colors.white,
              ),
            ],
            selectedItemColor: MyColors.primary,
            unselectedItemColor: MyColors.neutral,
            selectedLabelStyle: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            showUnselectedLabels: true,
          ),
        );
      },
    );
  }
}
