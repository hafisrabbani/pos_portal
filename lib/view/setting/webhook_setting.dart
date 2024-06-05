import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';
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
  bool isLoading = false;
  bool checkConnection = false;

  @override
  void initState() {
    super.initState();
    loadWebhook();
  }

  void loadWebhook() async {
    setState(() {
      isLoading = true;
    });
    final webhook = await _settingViewModel.getWebHook();
    setState(() {
      _webhookController.text = webhook;
      isLoading = false;
    });
  }

  Future<void> saveWebhook() async {
    setState(() {
      isLoading = true;
    });

    // Use the URL from the input field for the connection check
    String inputUrl = _webhookController.text;
    bool check = await _settingViewModel.checkConnectionWebhook(inputUrl);

    if (check) {
      await _settingViewModel.setWebHook(inputUrl);
      showSnackBar(context: context, message: 'Webhook saved successfully', color: MyColors.success);
      Navigator.pop(context);
    } else {
      showSnackBar(context: context, message: 'Failed to connect to the webhook', color: MyColors.error);
    }

    setState(() {
      checkConnection = check;
      isLoading = false;
    });
  }

  void showSnackBar({required BuildContext context, required String message, required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          topBar(context: context, title: 'Edit WebHook QRIS', isCanBack: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 32,
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                    label: 'Masukkan Webhook',
                    controller: _webhookController,
                    hintText: 'https://webhook.com',
                    isMultiLine: true,
                    onChanged: (p0) {
                      setState(() {});
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
        },
      ),
    );
  }
}
