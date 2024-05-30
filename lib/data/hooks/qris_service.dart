import 'dart:async';
import 'dart:convert';
import 'package:pos_portal/model/api/resp_transaction.dart';
import 'package:pos_portal/model/api/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class QrisService {
  static const String _webHookKey = 'webhook';
  Uri? url;
  SharedPreferences? _prefs;
  final Completer<void> _initCompleter = Completer<void>();

  QrisService(){
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final String? urlString = _prefs?.getString(_webHookKey);
    if (urlString != null) {
      url = Uri.parse(urlString);
    }
    _initCompleter.complete();
  }

  Future<RespPayment> createQris(RequestTransaction data) async {
    await _initCompleter.future;  // Ensure _init completes
    if (url == null) {
      throw Exception('Webhook URL is not set');
    }

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
