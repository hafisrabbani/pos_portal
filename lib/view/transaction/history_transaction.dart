import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pos_portal/data/type/transaction_status_type.dart';
import 'package:pos_portal/model/transaction_detail.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/utils/helpers.dart';
import 'package:pos_portal/view_model/printer_view_model.dart';
import 'package:pos_portal/view_model/transaction_view_model.dart';
import 'package:pos_portal/widgets/label_transaction.dart';
import 'package:pos_portal/widgets/payment_method_widget.dart';
import 'package:pos_portal/widgets/printer_button.dart';
import 'package:pos_portal/widgets/snackbar.dart';
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
  bool isLoading = true;
  String webhookUrl = '';

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
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadWebhookUrl(int idTrx) async {
    try {
      webhookUrl = (await transactionViewModel.getWebhookUrl(idTrx))!;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showCustomSnackbar(
        context: context,
        title: 'Error',
        message: 'Failed to load webhook URL',
        theme: SnackbarTheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: topBar(
            context: context, title: 'Transaction Detail', isCanBack: true),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.primary,
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        if (transactionDetail != null)
                          const SizedBox(height: 16),
                        Column(
                          children: [
                            rowItem(
                                'Status',
                                LabelTransaksi(
                                    status:
                                        transactionDetail?.transaction.status)),
                            rowItem(
                                'ID Transaksi',
                                commonText(
                                    '#${transactionDetail?.transaction.id.toString()}')),
                            rowItem(
                                'Tanggal',
                                commonText(convertDate(transactionDetail
                                        ?.transaction.CreatedTime
                                        .toString() ??
                                    '1970-01-01 00:00:00'))),
                            rowItem(
                                'Jam',
                                commonText(convertTime(transactionDetail
                                        ?.transaction.CreatedTime
                                        .toString() ??
                                    '1970-01-01 00:00:00'))),
                            rowItem(
                                'Total',
                                commonText(
                                    'Rp ${formatRupiah(transactionDetail?.transaction.TotalPayment ?? 0)}')),
                            rowItem(
                                'Metode Pembayaran',
                                LabelPayment(
                                    type: transactionDetail
                                        ?.transaction.paymentMethod)),
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
                                    color: MyColors.secondary,
                                    borderRadius: BorderRadius.circular(5)),
                                children: [
                                  tableRowItem(title: 'No', isHeader: true),
                                  tableRowItem(title: 'Nama', isHeader: true),
                                  tableRowItem(title: 'Qty', isHeader: true),
                                  tableRowItem(title: 'Harga', isHeader: true),
                                ],
                              ),
                              ...transactionDetail!.items
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                var item = entry.value;
                                return TableRow(
                                  children: [
                                    tableRowItem(title: (index + 1).toString()),
                                    tableRowItem(title: item.ProductName),
                                    tableRowItem(
                                        title: item.Quantity.toString()),
                                    tableRowItem(
                                        title:
                                            'Rp ${formatRupiah(item.Price)}'),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !isLoading
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    child: transactionDetail!.transaction.status ==
                            TransactionStatusType.paid
                        ? PrinterButton(
                            text: 'Print',
                            backgroundColor: MyColors.primary,
                            textColor: Colors.white,
                            onPressed: () {
                              if(printerViewModel.isConnected){
                                printerViewModel.printReceipt(
                                  transactionDetail!.transaction,
                                  transactionDetail!.items,
                                );
                              }else{
                                showCustomSnackbar(
                                  context: context,
                                  title: 'Belum ada printer yang terhubung',
                                  message: 'Sambungkan dulu printer di halaman pengaturan',
                                  theme: SnackbarTheme.error,
                                );
                              }
                            },
                          )
                        : transactionDetail!.transaction.status ==
                                TransactionStatusType.pending
                            ? PrinterButton(
                                text: 'Bayar',
                                backgroundColor: MyColors.primary,
                                textColor: Colors.white,
                                onPressed: () async {
                                  await loadWebhookUrl(
                                      transactionDetail!.transaction.id!);
                                  if (webhookUrl.isNotEmpty) {
                                    Navigator.pushNamed(
                                      context,
                                      RoutesName.qrisPayment,
                                      arguments: {
                                        'webhook_url': webhookUrl,
                                      },
                                    );
                                  } else {
                                    showCustomSnackbar(
                                      context: context,
                                      title: 'Error',
                                      message: 'Failed to load webhook URL',
                                      theme: SnackbarTheme.error,
                                    );
                                  }
                                },
                              )
                            : const SizedBox(),
                  )
                : const SizedBox(),
          ],
        ));
  }

  Widget rowItem(String title, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text(title,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              )),
        ),
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
