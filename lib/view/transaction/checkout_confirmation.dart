import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_portal/data/type/payment_method_type.dart';
import 'package:pos_portal/data/type/transaction_status_type.dart';
import 'package:pos_portal/model/api/resp_transaction.dart';
import 'package:pos_portal/model/api/transaction.dart';
import 'package:pos_portal/model/transaction.dart';
import 'package:pos_portal/model/transaction_item.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/utils/helpers.dart';
import 'package:pos_portal/view_model/transaction_view_model.dart';
import 'package:pos_portal/widgets/copy_clipboard.dart';
import 'package:pos_portal/widgets/table_row_widget.dart';
import 'package:pos_portal/widgets/topbar.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  TransactionViewModel transactionViewModel = TransactionViewModel();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final totalTransaksi = args['totalTransaksi'];
    final selectedItems = args['selectedItems'].toList();

    return Scaffold(
      appBar: topBar(
        title: 'Metode Pembayaran',
        isCanBack: true,
        context: context,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.secondaryDisabled,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: MyColors.primary,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          textBiasa(title: 'Total Transaksi'),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              'Rp ${formatRupiah(totalTransaksi)}',
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
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
                                      tableRowItem(
                                          title: item['quantity'].toString()),
                                      tableRowItem(title: 'Rp ${item['price']}'),
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
                  CashOrQris(
                    title: 'QRIS',
                    idTransaksi: 10000,
                    totalTransaksi: totalTransaksi,
                    selectedItems: selectedItems,
                  ),
                  CashOrQris(
                    title: 'Tunai',
                    idTransaksi: 10000,
                    totalTransaksi: totalTransaksi,
                    selectedItems: selectedItems,
                  ),
                ],
              ),
            ),
            if (isLoading) loadingWithBackdropFilter(),
          ],
        ),
      ),
    );
  }

  GestureDetector CashOrQris({
    required String title,
    required int idTransaksi,
    required int totalTransaksi,
    required List selectedItems,
  }) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        if (title == 'QRIS') {
          int? trxId = await transactionViewModel.createTrx(
              Transaction(
                NominalPayment: totalTransaksi,
                TotalPayment: totalTransaksi,
                Change: 0,
                status: TransactionStatusType.pending,
                paymentMethod: PaymentMethodType.QRIS,
              ),
              selectedItems
                  .map<TransactionItem>((e) => TransactionItem(
                ProductId: e['productId'],
                Quantity: e['quantity'],
                Price: e['price'].toInt(),
              ))
                  .toList());
          try {
            RespPayment respPayment = await transactionViewModel.createPaymentQris(RequestTransaction(
              orderId: trxId!,
              expiredMintute: 5,
              amount: totalTransaksi,
            ));
            Navigator.pushNamed(context, RoutesName.qrisPayment, arguments: {
              'webhook_url': respPayment.webhookUrl,
              'trxId': trxId,
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Terjadi kesalahan saat membuat pembayaran')),
            );
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        }
        if (title == 'Tunai') {
          setState(() {
            isLoading = false;
          });
          Navigator.pushNamed(context, RoutesName.cashPayment, arguments: {
            'totalTransaksi': totalTransaksi,
            'selectedItems': selectedItems,
          });
        }
      },
      child: Card(
        margin: const EdgeInsets.only(top: 16),
        elevation: 0,
        color: MyColors.secondaryDisabled,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/logo_${title.toLowerCase()}.svg',
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  Text textBiasa({required String title}) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget loadingWithBackdropFilter() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyColors.primary),
        ),
      ),
    );
  }
}
