import 'dart:convert';
import 'package:pos_portal/model/api/resp_transaction.dart';
import 'package:pos_portal/model/api/transaction.dart';
import 'package:http/http.dart' as http;

class QrisService {
  final Uri url = Uri.parse('https://e56e-103-24-56-34.ngrok-free.app'
      '/api/v1');

  Future<RespPayment> createQris(RequestTransaction data) async {
    final response = await http.post(
      Uri.parse('$url/payment/create-transaction'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data.toJson()),
    );
    print("response createQris: ${response.body}");
    if (response.statusCode == 200) {
      final responsePayment = await http.post(
        Uri.parse('$url/payment/create-payment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'order_id': data.orderId.toString(),
        }),
      );
      print("responsePayment: ${responsePayment.body}");
      if (responsePayment.statusCode == 200) {
        return RespPayment.fromJson(jsonDecode(responsePayment.body));
      } else {
        throw Exception('Failed to create payment');
      }
    } else {
      throw Exception('Failed to create transaction');
    }
  }
}
