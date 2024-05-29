import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_portal/model/transaction.dart';
import 'package:pos_portal/view_model/transaction_view_model.dart';
import 'package:pos_portal/widgets/card_transaction.dart';
import 'package:pos_portal/widgets/search_field.dart';
import 'package:pos_portal/widgets/topbar.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Transaction> transaction = [];
  TransactionViewModel transactionViewModel = TransactionViewModel();
  final TextEditingController searchController = TextEditingController();

  void loadTrx() async {
    transaction = await transactionViewModel.getAll();
    print('transaction : $transaction');
    setState(() {
      transaction = transaction;
    });
  }

  @override
  void initState() {
    loadTrx();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context: context, title: 'Transaksi'),
      body: SafeArea(
        child: Column(
          children: [
            SearchField(
              controller: searchController,
              isAdaBatal: false,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: transaction.length,
                itemBuilder: (context, index) {
                  return CardListTransaction(
                    transaction: transaction[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
