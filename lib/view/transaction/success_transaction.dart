import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_portal/model/transaction.dart';
import 'package:pos_portal/model/transaction_detail.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/utils/helpers.dart';
import 'package:pos_portal/view_model/printer_view_model.dart';
import 'package:pos_portal/view_model/transaction_view_model.dart';
import 'package:pos_portal/widgets/floating_button.dart';

class SuccessPayment extends StatefulWidget {
  const SuccessPayment({super.key});

  @override
  State<SuccessPayment> createState() => _SuccessPaymentState();
}

class _SuccessPaymentState extends State<SuccessPayment> {
  final TransactionViewModel transactionViewModel = TransactionViewModel();
  final PrinterViewModel printerViewModel = PrinterViewModel();
  Transaction? transaction;
  TransactionDetail? transactionDetail;

  void loadTransaction(int idTrx) async {
    transaction = await transactionViewModel.getById(idTrx);
    transactionDetail = await transactionViewModel.getTransactionDetails(idTrx);
    setState(() {
      transaction = transaction;
      transactionDetail = transactionDetail;
    });
  }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    print('args: $args');
    final int idTrx = args['trxId'];
    loadTransaction(idTrx);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(RoutesName.home);
        return true;
      },
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1B6ED4),
                  Color(0xFF051529),
                ],
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFF3F7FC),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Lottie.asset('assets/success.json',
                            width: 200, height: 200),
                        Image.asset('assets/success.png',
                            width: 120, height: 120),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Transaksi Sukses',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MyColors.onSecondary),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: 'ID Transaksi: ',
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: idTrx.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: MyColors.primary,
                      ),
                      child: Column(
                        children: [
                          Text('Metode Pembayaran : ${transaction?.paymentMethod}',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 0.3,
                          ),
                          Text(
                            'Total Pembayaran : ${formatRupiah(transaction?.TotalPayment ?? 0)}',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingButtonDefault(
                    title: 'Cetak Struk',
                    actionPressed: () {
                      printerViewModel.printReceipt(
                        transactionDetail!.transaction,
                        transactionDetail!.items,
                      );
                    },
                    heroTag: 'cetakStruk',
                  ),
                  FloatingButtonDefault(
                    title: 'Selesai',
                    actionPressed: () {
                      Navigator.pushNamed(context, RoutesName.home);
                    },
                    heroTag: 'selesaiTransaksi',
                    isFilled: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

