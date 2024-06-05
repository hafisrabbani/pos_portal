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

class FailedTransaction extends StatefulWidget {
  const FailedTransaction({super.key});

  @override
  State<FailedTransaction> createState() => _FailedTransactionState();
}

class _FailedTransactionState extends State<FailedTransaction> {
  final TransactionViewModel transactionViewModel = TransactionViewModel();
  final PrinterViewModel printerViewModel = PrinterViewModel();
  Transaction? transaction;
  TransactionDetail? transactionDetail;
  bool isLoading = true;

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
    transaction = await transactionViewModel.getById(idTrx);
    transactionDetail = await transactionViewModel.getTransactionDetails(idTrx);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                  MyColors.error,
                  Color(0xFF440808),
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
                        Lottie.asset('assets/failed.json',
                            width: 200, height: 200),
                        Image.asset('assets/failed.png',
                            width: 120, height: 120),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Transaksi Gagal',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MyColors.error),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Waktu Pembayaran Habis',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'ID Transaksi: ',
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: transaction?.id.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: const LinearGradient(
                            begin: AlignmentDirectional.bottomStart,
                            end: AlignmentDirectional.topEnd,
                            colors: [Color(0xFF9F1B14), Color(0xFFEB6760)],
                          )),
                      child: Column(
                        children: [
                          Text(
                            'Metode Pembayaran : ${convertPaymentMethod(transaction!.paymentMethod.toString())}',
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
                    customColor: MyColors.error,
                    isOutlineTransparent: true,
                    title: 'Gagal',
                    actionPressed: () {
                      Navigator.pushReplacementNamed(context, RoutesName.home);
                    },
                    heroTag: 'gagalTransaksi',
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
