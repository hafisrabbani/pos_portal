import 'package:flutter/material.dart';
import 'package:pos_portal/view_model/setting_view_model.dart';
import 'package:pos_portal/widgets/floating_button.dart';
import 'package:pos_portal/widgets/input_field.dart';
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                    label: 'Masukkan Header Struk',
                    controller: headerController,
                    hintText: 'Isikan header disini',
                    isMultiLine: true,
                    onChanged: (p0) {
                      setState(() {
                        print(
                            "foote contol : ${footerController.text} header contol : ${headerController.text}");
                      });
                    },
                  ),
                  InputField(
                    label: 'Masukkan Footer Struk',
                    controller: footerController,
                    hintText: 'Isikan footer disini',
                    isMultiLine: true,
                    onChanged: (p0) {
                      setState(() {
                        print(
                            "foote contol : ${footerController.text} header contol : ${headerController.text}");
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: FloatingButtonDefault(
          isFilled: true,
          isDisabled:
              (headerController.text.isEmpty || footerController.text.isEmpty),
          heroTag: "product",
          title: 'Simpan',
          actionPressed: () {
            saveStruk();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
