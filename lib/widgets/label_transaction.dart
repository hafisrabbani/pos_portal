import 'package:flutter/material.dart';
import 'package:pos_portal/data/type/transaction_status_type.dart';
import 'package:pos_portal/utils/colors.dart';

class LabelTransaksi extends StatelessWidget {
  final TransactionStatusType? status;
  final String text;
  const LabelTransaksi({
    super.key,
    this.status = TransactionStatusType.pending,
    this.text = 'Menunggu',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(5),
      child: Text(
        _text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: 9,
          color: _textColor,
        ),
      ),
    );
  }

  Color get _bgColor {
    switch (status) {
      case TransactionStatusType.paid:
        return MyColors.bgSuccess;
      case TransactionStatusType.failed:
        return MyColors.bgError;
      case TransactionStatusType.pending:
        return MyColors.bgWarning;
      default:
        return MyColors.bgWarning;
    }
  }

  Color get _textColor {
    switch (status) {
      case TransactionStatusType.paid:
        return MyColors.success;
      case TransactionStatusType.failed:
        return MyColors.error;
      case TransactionStatusType.pending:
        return MyColors.warning;
      default:
        return MyColors.warning;
    }
  }

  String get _text {
    switch (status) {
      case TransactionStatusType.paid:
        return 'Berhasil';
      case TransactionStatusType.failed:
        return 'Dibatalkan';
      case TransactionStatusType.pending:
        return 'Menunggu';
      default:
        return 'Menunggu';
    }
  }
}
