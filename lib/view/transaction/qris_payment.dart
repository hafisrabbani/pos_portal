import 'package:flutter/material.dart';
import 'package:pos_portal/data/type/transaction_status_type.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/view_model/transaction_view_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
class QrisPayment extends StatefulWidget {
  const QrisPayment({super.key});

  @override
  State<QrisPayment> createState() => _QrisPaymentState();
}

class _QrisPaymentState extends State<QrisPayment> {
  late final WebViewController _controller;
  final TransactionViewModel _transactionViewModel = TransactionViewModel();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final webhookUrl = args['webhook_url'];
    print('webhookUrl: $webhookUrl');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menunggu Pembayaran'),
      ),
      body: WebView(
        navigationDelegate: (action) async {
          final uri = Uri.parse(action.url);
          final orderId = int.tryParse(uri.queryParameters['order_id'] ?? '');
          if (orderId == null) return NavigationDecision.navigate;

          TransactionStatusType statusType;
          String routeName;

          if (action.url.contains('success')) {
            statusType = TransactionStatusType.paid;
            routeName = RoutesName.successPayment;
          } else if (action.url.contains('failed')) {
            statusType = TransactionStatusType.failed;
            routeName = RoutesName.failedPayment;
          } else {
            return NavigationDecision.navigate;
          }

          bool status = await _transactionViewModel.updatePayment(orderId, statusType);
          if (status) {
            Navigator.pushReplacementNamed(context, routeName, arguments: {'trxId': orderId});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Terjadi kesalahan saat mengupdate status pembayaran')),
            );
          }

          return NavigationDecision.navigate;
        },
        initialUrl: webhookUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
      )
    );
  }
}
