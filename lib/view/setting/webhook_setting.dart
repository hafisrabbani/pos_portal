import 'package:flutter/material.dart';
import 'package:pos_portal/view_model/setting_view_model.dart';
import 'package:pos_portal/widgets/floating_button.dart';
import 'package:pos_portal/widgets/input_field.dart';
import 'package:pos_portal/widgets/topbar.dart';
class WebHookPage extends StatefulWidget {
  const WebHookPage({super.key});

  @override
  State<WebHookPage> createState() => _WebHookPageState();
}

class _WebHookPageState extends State<WebHookPage> {
  final TextEditingController _webhookController = TextEditingController();
  final SettingViewModel _settingViewModel = SettingViewModel();

  void loadWebhook() async {
    final webhook = await _settingViewModel.getWebHook();
    setState(() {
      _webhookController.text = webhook;
    });
  }

  void saveWebhook() async {
    await _settingViewModel.setWebHook(_webhookController.text);
  }

  @override
  void initState() {
    super.initState();
    loadWebhook();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context: context, title: 'Edit WebHook QRIS'),
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
                    label: 'Masukkan Webhook',
                    controller: _webhookController,
                    hintText: 'https://webhook.com',
                    isMultiLine: true,
                    onChanged: (p0) {
                      setState(() {
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingButtonDefault(
        isFilled: true,
        isDisabled: _webhookController.text.isEmpty,
        heroTag: "product",
        title: 'Simpan',
        actionPressed: () {
          saveWebhook();
          Navigator.pop(context);
        },
      ),
    );
  }
}
