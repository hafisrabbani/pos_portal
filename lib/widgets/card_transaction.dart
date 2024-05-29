import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_portal/model/transaction.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/utils/helpers.dart';
import 'package:pos_portal/widgets/label_transaction.dart';

class CardListTransaction extends StatefulWidget {
  final Transaction transaction;

  const CardListTransaction({
    super.key,
    required this.transaction,
  });

  @override
  State<CardListTransaction> createState() => _CardListTransactionState();
}

class _CardListTransactionState extends State<CardListTransaction> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutesName.transactionDetail,
          arguments: {
            'trxId': widget.transaction.id,
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFE0E8F2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MyColors.secondaryDisabled,
              ),
              height: 46.48,
              width: 46.48,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/svg/icon_duit.svg',
                  height: 20,
                ),
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rp ${formatRupiah(widget.transaction.TotalPayment)}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      'ID Transaksi',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        color: Color(0x9926273A),
                      ),
                    ),
                    Text(
                      '#${widget.transaction.id!.toString()}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    LabelTransaksi(status: widget.transaction.status),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      // convert to date ex : 12 Mei 2024
                      convertDate(widget.transaction.CreatedTime!),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        color: Color(0x9926273A),
                      ),
                    ),
                    Text(
                      // convert to time ex : 12:00
                      convertTime(widget.transaction.CreatedTime!),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        color: Color(0x9926273A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
