import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:pos_portal/model/transaction.dart';
import 'package:pos_portal/model/transaction_item.dart';
import 'package:pos_portal/utils/helpers.dart';
import 'package:pos_portal/view_model/setting_view_model.dart';

class PrinterViewModel {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter? printer = BlueThermalPrinter.instance;
  SettingViewModel _settingViewModel = SettingViewModel();
  String _strukHeader = '';
  String _strukFooter = '';
  bool _isConnected = false;
  bool _isScanning = false;
  bool get isConnected => _isConnected;
  bool get isScanning => _isScanning;

  PrinterViewModel() {
    _init();
  }

  Future<void> _init() async {
    _strukHeader = await _settingViewModel.getStrukHeader();
    _strukFooter = await _settingViewModel.getStrukFooter();
    _isConnected = (await checkConnection())!;
    print('Connected: $_isConnected');
  }

  Future<void> getDevices() async {
    _isScanning = true;
    List<BluetoothDevice> bondedDevices = await printer!.getBondedDevices();
    devices = bondedDevices;
    devices.forEach((device) {
      print('Device: ${device.name}');
    });
    _isScanning = false;
  }

  Future<List<BluetoothDevice>> listDevice() async {
    return await printer!.getBondedDevices();
  }

  void selectDevice(BluetoothDevice? device) {
    selectedDevice = device;
  }

  Future<void> toggleConnection() async {
    if (selectedDevice != null) {
      if (_isConnected) {
        await printer!.disconnect();
        _isConnected = false;
      } else {
        bool connected = await printer!.connect(selectedDevice!);
        if (connected) {
          _isConnected = true;
        }
      }
    }
  }

  Future<bool?> checkConnection() async {
    bool? isConnected = await printer!.isConnected;
    if (isConnected == true) {
      _isConnected = true;
    } else {
      _isConnected = false;
    }
    return await printer!.isConnected;
  }

  bool printReceipt(Transaction transaction, List<TransactionItem> items) {
    if (_isConnected) {
      printer!.printNewLine();
      // HEADER
      printer!.printCustom(_strukHeader, 1, 1);
      printer!.printNewLine();
      // END HEADER

      // BODY
      printer!.printLeftRight('Trx ID : ', transaction.id.toString(), 1);
      printer!.printLeftRight('Tgl : ', convertDate(transaction.CreatedTime!), 1);
      printer!.printLeftRight('Jam : ', convertTime(transaction.CreatedTime!), 1);
      printer!.printCustom('--------------------------------', 1, 1);
      printer!.printNewLine();
      items.forEach((item) {
        printer!.printCustom(item.ProductName, 1, 0);
        printer!.printLeftRight(
            '${item.Quantity} pcs', 'Rp ${formatRupiah(item.Price)}', 1);
      });
      printer!.printCustom('--------------------------------', 1, 1);
      printer!.printLeftRight('Total : ',
          'Rp ${formatRupiah(transaction.TotalPayment ?? 0)}', 1);
      printer!.printLeftRight('Pembayaran : ', convertPaymentMethod(transaction.paymentMethod.toString()), 1);
      printer!.printLeftRight('Tunai : ', 'Rp ${formatRupiah(transaction.NominalPayment ?? 0)}', 1);
      printer!.printLeftRight('Kembalian : ', 'Rp ${formatRupiah(transaction.Change ?? 0)}', 1);
      printer!.printCustom('--------------------------------', 1, 1);
      // END BODY

      // FOOTER
      printer!.printCustom(_strukFooter, 1, 1);
      printer!.printNewLine();
      printer!.printCustom('Powered by Pos Portal', 1, 1);
      printer!.printNewLine();
      // END FOOTER
      printer!.paperCut();
      return true;
    } else {
      return false;
    }
  }

  void printTest() {
    if (_isConnected) {
      printer!.printNewLine();
      printer!.printCustom('Hello World', 3, 1);
      printer!.paperCut();
    }
  }
}
