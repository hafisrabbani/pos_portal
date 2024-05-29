import 'package:flutter/material.dart';
import 'package:pos_portal/data/type/transaction_status_type.dart';
import 'package:pos_portal/model/transaction.dart';
import 'package:pos_portal/model/transaction_item.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/view_model/transaction_view_model.dart';
import 'package:pos_portal/widgets/change_widget.dart';
import 'package:pos_portal/widgets/floating_button.dart';
import 'package:pos_portal/widgets/input_field.dart';
import 'package:pos_portal/widgets/table_row_widget.dart';
import 'package:pos_portal/widgets/topbar.dart';

class CashPayment extends StatefulWidget {
  const CashPayment({super.key});

  @override
  State<CashPayment> createState() => _CashPaymentState();
}

class _CashPaymentState extends State<CashPayment> {
  final TextEditingController uangDiterimaController = TextEditingController();
  int? uangDiterima = 0;
  int? kembalian;
  final TransactionViewModel transactionViewModel = TransactionViewModel();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final totalTransaksi = args['totalTransaksi'];
    final selectedItems = args['selectedItems'].toList();
    print('selectedItems: $selectedItems');
    print('totalTransaksi: $totalTransaksi');
    return Scaffold(
      appBar: topBar(
        context: context,
        title: 'Detail Pembayaran',
        isCanBack: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Table(
                  border: TableBorder.all(
                      color: MyColors.primary,
                      borderRadius: BorderRadius.circular(5)),
                  columnWidths: const {
                    0: FixedColumnWidth(35.0),
                    1: FlexColumnWidth(),
                    2: FixedColumnWidth(40.0),
                    3: FixedColumnWidth(100.0),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                          color: MyColors.tertiary,
                          borderRadius: BorderRadius.circular(5)),
                      children: [
                        tableRowItem(title: 'No', isHeader: true),
                        tableRowItem(title: 'Nama', isHeader: true),
                        tableRowItem(title: 'Qty', isHeader: true),
                        tableRowItem(title: 'Harga', isHeader: true),
                      ],
                    ),
                    ...selectedItems.asMap().entries.map((entry) {
                      int index = entry.key;
                      var item = entry.value;
                      return TableRow(
                        children: [
                          tableRowItem(title: (index + 1).toString()),
                          tableRowItem(title: item['name']),
                          tableRowItem(title: item['quantity'].toString()),
                          tableRowItem(title: 'Rp ${item['price']}'),
                        ],
                      );
                    }).toList(),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 36),
                  child: InputField(
                    controller: uangDiterimaController,
                    hintText: 'Rp 0',
                    label: 'Uang Diterima',
                    isDuit: true,
                    onNilaiAngkaChanged: (value) {
                      setState(() {
                        uangDiterima = value;
                        if (uangDiterima! >= totalTransaksi) {
                          kembalian = (uangDiterima! - totalTransaksi) as int?;
                        } else {
                          kembalian = 0;
                        }
                      });
                    },
                  ),
                ),
                ChangeWidget(
                  change: kembalian,
                  totalTransaction: totalTransaksi,
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: FloatingButtonDefault(
          title: 'Bayar',
          heroTag: 'toMetodeBayar',
          isFilled: true,
          actionPressed: () async {
            int? item = await transactionViewModel.createTrx(
              Transaction(
                NominalPayment: uangDiterima!,
                TotalPayment: totalTransaksi,
                Change: kembalian!,
                status: TransactionStatusType.paid,
              ),
              selectedItems
                  .map<TransactionItem>(
                      (Map<String, dynamic> e) => TransactionItem(
                            ProductId: e['productId'],
                            Quantity: e['quantity'],
                            Price: e['price'].toInt(),
                          ))
                  .toList(),
            );
            Navigator.pushNamed(context, RoutesName.successPayment, arguments: {
              'trxId': item,
            });
          },
          isDisabled: !(uangDiterima! >= totalTransaksi),
          // isDisabled: !(uangDiterima! >= widget.totalTransaksi),
        ),
      ),
    );
  }
}
