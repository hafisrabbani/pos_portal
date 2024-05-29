import 'package:flutter/material.dart';
import 'package:pos_portal/data/type/payment_method_type.dart';
import 'package:pos_portal/data/type/transaction_status_type.dart';
import 'package:pos_portal/utils/colors.dart';

class LabelPayment extends StatelessWidget {
  final PaymentMethodType? type;
  const LabelPayment({
    super.key,
    this.type = PaymentMethodType.CASH,
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
    switch (type) {
      case PaymentMethodType.CASH:
        return MyColors.bgSuccess;
      case PaymentMethodType.QRIS:
        return MyColors.secondary;
      default:
        return MyColors.bgWarning;
    }
  }

  Color get _textColor {
    switch (type) {
      case PaymentMethodType.CASH:
        return MyColors.success;
      case PaymentMethodType.QRIS:
        return MyColors.primary;
      default:
        return MyColors.warning;
    }
  }

  String get _text {
    switch (type) {
      case PaymentMethodType.CASH:
        return 'Tunai';
      case PaymentMethodType.QRIS:
        return 'QRIS';
      default:
        return '-';
    }
  }
}
