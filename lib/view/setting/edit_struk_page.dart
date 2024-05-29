import 'package:flutter/material.dart';
import 'package:pos_portal/view_model/setting_view_model.dart';
import 'package:pos_portal/widgets/floating_button.dart';
import 'package:pos_portal/widgets/topbar.dart';
import '../../widgets/customTextField.dart';

class EditStruk extends StatefulWidget {
  const EditStruk({super.key});

  @override
  State<EditStruk> createState() => _EditStrukState();
}

class _EditStrukState extends State<EditStruk> {
  final TextEditingController headerController = TextEditingController();
  final TextEditingController footerController = TextEditingController();
  final SettingViewModel _settingViewModel = SettingViewModel();

  void loadStruk() async {
    final headerStruk = await _settingViewModel.getStrukHeader();
    final footerStruk = await _settingViewModel.getStrukFooter();
    print('headerStruk: $headerStruk');
    print('footerStruk: $footerStruk');
    setState(() {
      headerController.text = headerStruk;
      footerController.text = footerStruk;
    });
  }

  void saveStruk() async {
    await _settingViewModel.setStrukHeader(headerController.text);
    await _settingViewModel.setStrukFooter(footerController.text);
  }

  @override
  void initState() {
    super.initState();
    loadStruk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context: context, title: 'Edit Struk'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 32,
              ),
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Masukkan Header',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: headerController,
                    labelText: 'Isikan Header Disini',
                    hintText: 'Isikan Header Disini',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Masukkan Footer',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: footerController,
                    labelText: 'Isikan Footer Disini',
                    hintText: 'Isikan Footer Disini',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:  FloatingButtonDefault(
        heroTag: "product",
        title: 'Simpan',
        actionPressed: () {
          saveStruk();
          Navigator.pop(context);
        },
      ),
    );
  }
}
