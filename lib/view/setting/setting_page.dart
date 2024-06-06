import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/widgets/topbar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context: context, title: 'Pengaturan', isCanBack: false),
      body: Column(
        children: [
          ListTile(
            title: const Text(
              'Sambungkan Printer',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            subtitle: const Text('Pilih Printer yang akan digunakan',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w300)),
            leading: Icon(
              Icons.print_rounded,
              color: MyColors.primary,
              size: 24,
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
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            subtitle: const Text(
              'Ubah Header dan Footer Struk',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
            ),
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
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            subtitle: const Text('Setting API Payment',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w300)),
            leading: Icon(
              Icons.webhook_rounded,
              color: MyColors.primary,
              size: 24,
            ),
            onTap: () {
              Navigator.pushNamed(context, RoutesName.settingWebHook);
            },
          ),
          ListTile(
            title: const Text(
              'Backup/Restore Data',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            subtitle: const Text('Simpan dan Pulihkan Data',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w300)),
            leading: Icon(
              Icons.folder_copy_outlined,
              color: MyColors.primary,
              size: 24,
            ),
            onTap: () {
              Navigator.pushNamed(context, RoutesName.backupRestore);
            },
          ),
        ],
      ),
    );
  }
}
