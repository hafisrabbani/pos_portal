import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/view_model/printer_view_model.dart';
import 'package:pos_portal/widgets/floating_button.dart';
import 'package:pos_portal/widgets/snackbar.dart';
import 'package:pos_portal/widgets/topbar.dart';

class SettingPrinter extends StatefulWidget {
  const SettingPrinter({super.key});
  @override
  State<SettingPrinter> createState() => _SettingPrinterState();
}

class _SettingPrinterState extends State<SettingPrinter> {
  final PrinterViewModel printerViewModel = PrinterViewModel();

  @override
  void initState() {
    super.initState();
    printerViewModel.getDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(
          context: context, title: 'Sambungkan Printer', isCanBack: true),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Perbarui perangkat yang tersedia',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 20,
                      )),
                  onPressed: () {
                    printerViewModel.getDevices();
                  },
                )
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Perangkat',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: MyColors.primary,
                  width: 1,
                  style: BorderStyle.solid,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<BluetoothDevice>(
                style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    color: MyColors.primary,
                    fontWeight: FontWeight.w500),
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(30),
                isExpanded: true,
                value: printerViewModel.selectedDevice,
                hint: const Text('Pilih Perangkat'),
                items: printerViewModel.devices.map((device) {
                  print('device: $device');
                  return DropdownMenuItem(
                    value: device,
                    child: Text(device.name!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    printerViewModel.selectDevice(value);
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            StatusConnection(printerViewModel: printerViewModel),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    printerViewModel.selectedDevice == null
                        ? showCustomSnackbar(
                            context: context,
                            title: 'Belum ada perangkat yang dipilih',
                            message: 'Pilih perangkat terlebih dahulu',
                            theme: SnackbarTheme.error)
                        : printerViewModel.toggleConnection();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width - 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: printerViewModel.selectedDevice == null
                          ? MyColors.neutral
                          : printerViewModel.isConnected
                              ? MyColors.error
                              : MyColors.primary,
                    ),
                    child: Center(
                      child: Text(
                        printerViewModel.isConnected
                            ? 'Putuskan'
                            : 'Sambungkan',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: printerViewModel.isConnected,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      printerViewModel.isConnected
                          ? printerViewModel.printTest()
                          : () {};
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      width: MediaQuery.of(context).size.width - 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: MyColors.secondary,
                      ),
                      child: Center(
                        child: Text(
                          'Print Test',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: MyColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusConnection extends StatelessWidget {
  const StatusConnection({
    super.key,
    required this.printerViewModel,
  });

  final PrinterViewModel printerViewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Status: ',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: MyColors.bgError,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Text(
            printerViewModel.isConnected ? 'Connected' : 'Not Connected',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: printerViewModel.isConnected
                  ? MyColors.success
                  : MyColors.error,
            ),
          ),
        ),
      ],
    );
  }
}
