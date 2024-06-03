import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_portal/routes/route_name.dart';
import '../../widgets/topbar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 17,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
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
          ListTile(
            title: const Text(
              'Edit Webhook',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            subtitle: const Text('Setting API Payment'),
            leading: SvgPicture.asset(
              'assets/svg/icon_struk.svg',
              width: 24, // adjust the width as needed
              height: 24, // adjust the height as needed
            ),
            onTap: () {
              Navigator.pushNamed(context, RoutesName.settingWebHook);
            },
          ),
        ],
      ),
    );
  }
}
