import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:pos_portal/view_model/printer_view_model.dart';

class SettingPrinter extends StatefulWidget {
  const SettingPrinter({super.key});
  @override
  State<SettingPrinter> createState() => _SettingPrinterState();
}

class _SettingPrinterState extends State<SettingPrinter> {
  final PrinterViewModel printerViewModel = PrinterViewModel();
  bool isPrinterConnected = false;

  @override
  void initState() {
    super.initState();
    printerViewModel.getDevices();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<BluetoothDevice>(
              value: printerViewModel.selectedDevice,
              hint: const Text('Select Device'),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    printerViewModel.getDevices();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Atur padding
                  ),
                  child: const Text('Refresh Devices'),
                ),
                ElevatedButton(
                  onPressed: () {
                    printerViewModel.toggleConnection();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Atur padding
                  ),
                  child: const Text('Connect'),
                ),
                ElevatedButton(
                  onPressed: () {
                    printerViewModel.printTest();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Atur padding
                  ),
                  child: const Text('Print Text'),
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     DropdownButton<BluetoothDevice>(
            //       value: printerViewModel.selectedDevice,
            //       hint: const Text('Select Device'),
            //       items: printerViewModel.devices.map((device) {
            //         return DropdownMenuItem(
            //           value: device,
            //           child: Text(device.name!),
            //         );
            //       }).toList(),
            //       style: const TextStyle(
            //         color: Colors.black,
            //       ),
            //       icon: const Icon(Icons.arrow_drop_down),
            //       iconSize: 24,
            //       onChanged: (value) {
            //         setState(() {
            //           printerViewModel.selectDevice(value);
            //         });
            //       },
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         printerViewModel.toggleConnection();
            //       },
            //       child: Container(
            //         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            //         decoration: BoxDecoration(
            //           color: printerViewModel.isConnected ? Colors.red : Colors.green,
            //           borderRadius: BorderRadius.circular(5),
            //         ),
            //         child: Text(
            //           printerViewModel.isConnected ? 'Disconnect' : 'Connect',
            //           style: const TextStyle(
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         printerViewModel.getDevices();
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.blue,
            //         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            //       ),
            //       child: const Icon(Icons.refresh, color: Colors.white),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
