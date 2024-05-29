import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:pos_portal/utils/colors.dart';

String formatRupiah(int nominal) {
  return NumberFormat.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: 0,
  ).format(nominal);
}

Color getColorByStock(int? stock) {
  if (stock == null || stock > 10) {
    return MyColors.primary;
  } else if (stock > 3) {
    return MyColors.warning;
  } else {
    return MyColors.error;
  }
}

String convertDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  return DateFormat('dd MMMM yyyy').format(dateTime);
}

String convertTime(String date) {
  DateTime dateTime = DateTime.parse(date);
  return DateFormat('HH:mm').format(dateTime);
}

String convertPaymentMethod(String paymentMethod) {
  if (paymentMethod.contains('qris') || paymentMethod.contains('QRIS')) {
    return 'QRIS';
  } else {
    return 'Tunai';
  }
}
