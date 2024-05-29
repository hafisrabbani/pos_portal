import 'package:flutter/material.dart';
import 'package:pos_portal/model/transaction_detail.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/utils/helpers.dart';
import 'package:pos_portal/view_model/printer_view_model.dart';
import 'package:pos_portal/view_model/transaction_view_model.dart';
import 'package:pos_portal/widgets/label_transaction.dart';
import 'package:pos_portal/widgets/payment_method_widget.dart';
import 'package:pos_portal/widgets/printer_button.dart';
import 'package:pos_portal/widgets/table_row_widget.dart';
import 'package:pos_portal/widgets/topbar.dart';

class HistoryTransaction extends StatefulWidget {
  const HistoryTransaction({super.key});

  @override
  State<HistoryTransaction> createState() => _HistoryTransactionState();
}

class _HistoryTransactionState extends State<HistoryTransaction> {
  final TransactionViewModel transactionViewModel = TransactionViewModel();
  TransactionDetail? transactionDetail;
  final PrinterViewModel printerViewModel = PrinterViewModel();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      final int idTrx = args['trxId'];
      loadTransaction(idTrx);
    });
  }

  void loadTransaction(int idTrx) async {
    transactionDetail = await transactionViewModel.getTransactionDetails(idTrx);
    transactionDetail?.items.forEach((element) {
      print('item: ${element.ProductName}');
    });
    setState(() {
      transactionDetail = transactionDetail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context: context, title: 'Transaction Detail'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                if (transactionDetail != null) const SizedBox(height: 16),
                Column(
                  children: [
                    rowItem(
                        'Status',
                        LabelTransaksi(
                            status: transactionDetail?.transaction.status)),
                    rowItem(
                        'ID Transaksi',
                        commonText(
                            '#${transactionDetail?.transaction.id.toString()}')),
                    rowItem(
                        'Tanggal',
                        commonText(convertDate(
                            transactionDetail?.transaction.CreatedTime ?? ''))),
                    rowItem(
                        'Jam',
                        commonText(convertTime(
                            transactionDetail?.transaction.CreatedTime ?? ''))),
                    rowItem(
                        'Total',
                        commonText(
                            'Rp ${formatRupiah(transactionDetail?.transaction.TotalPayment ?? 0)}')),
                    rowItem(
                        'Metode Pembayaran',
                        LabelPayment(
                            type:
                                transactionDetail?.transaction.paymentMethod)),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  child: Table(
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
                            color: MyColors.primary,
                            borderRadius: BorderRadius.circular(5)),
                        children: [
                          tableRowItem(title: 'No', isHeader: true),
                          tableRowItem(title: 'Nama', isHeader: true),
                          tableRowItem(title: 'Qty', isHeader: true),
                          tableRowItem(title: 'Harga', isHeader: true),
                        ],
                      ),
                      ...transactionDetail!.items.asMap().entries.map((entry) {
                        int index = entry.key;
                        var item = entry.value;
                        return TableRow(
                          children: [
                            tableRowItem(title: (index + 1).toString()),
                            tableRowItem(title: item.ProductName),
                            tableRowItem(title: item.Quantity.toString()),
                            tableRowItem(
                                title: 'Rp ${formatRupiah(item.Price)}'),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
                PrinterButton(
                    text: 'Print',
                    backgroundColor: MyColors.secondary,
                    textColor: MyColors.primary,
                    onPressed: () {
                      printerViewModel.printReceipt(
                        transactionDetail!.transaction,
                        transactionDetail!.items,
                      );
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rowItem(String title, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 14,
            )),
        child,
      ],
    );
  }

  Widget commonText(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    );
  }
}
