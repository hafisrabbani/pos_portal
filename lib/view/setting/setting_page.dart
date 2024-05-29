import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_portal/routes/route_name.dart';
import '../../widgets/topbar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(
        context: context,
        title: 'Pengaturan',
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text(
              'Setting Printer',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            subtitle: const Text('Pilih Printer yang akan digunakan'),
            leading: SvgPicture.asset(
              'assets/svg/icon_gembok.svg',
              width: 24, // adjust the width as needed
              height: 24, // adjust the height as needed
            ),
            onTap: () {
              Navigator.pushNamed(context, RoutesName.settingPrinter);
            },
          ),
          ListTile(
            title: const Text(
              'Edit Struk',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            subtitle: const Text('Ubah Header dan Footer Struk'),
            leading: SvgPicture.asset(
              'assets/svg/icon_struk.svg',
              width: 24, // adjust the width as needed
              height: 24, // adjust the height as needed
            ),
            onTap: () {
              Navigator.pushNamed(context, RoutesName.settingStruk);
            },
          ),
        ],
      ),
    );
  }
}
