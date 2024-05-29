import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/utils/helpers.dart';
import 'package:pos_portal/widgets/copy_clipboard.dart';

class CardTotalTransaksi extends StatelessWidget {
  final bool isQris;
  final int transactionId;
  final int totalTransaksi;

  CardTotalTransaksi(
      {required this.transactionId,
      super.key,
      this.isQris = false,
      required this.totalTransaksi});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: MyColors.secondaryDisabled,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: MyColors.primary, // Warna tepi card
                    width: 1, // Lebar tepi card
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    textBiasa(title: 'Total Transaksi'),
                    Padding(
                      padding: isQris
                          ? const EdgeInsets.symmetric(vertical: 4)
                          : const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Rp ${formatRupiah(totalTransaksi)}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: isQris ? 18 : 32,
                        ),
                      ),
                    ),
                    Container(
                      child: isQris
                          ? textBiasa(title: '#${transactionId.toString()}')
                          : Column(
                              children: [
                                textBiasa(title: 'ID Transaksi'),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: CopyIdClipboard(
                                      transactionId: transactionId),
                                )
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text textBiasa({required String title}) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
