import 'package:flutter/material.dart';
import 'package:mini_project_bank_sampah/model/transaction.dart';
import 'package:mini_project_bank_sampah/view/widget/balance_info_card.dart';
import 'package:provider/provider.dart';

import '../../../common/utils.dart';
import '../../../viewmodel/main_viewmodel.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saldo Anda"),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: BalanceInfoCard(),
          ),
          // tarik saldo BUTTON
          //
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/widthdraw");
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                foregroundColor: Colors.white,
                backgroundColor: hexToColor("#7A9D30"),
              ),
              child: const Text("Tarik"),
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          // riwayat transaksi
          Row(
            children: [
              Text(
                "  Riwayat Transaksi",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(
            color: Colors.black,
          ),
          Builder(builder: (context) {
            final transactions = context.watch<MainViewmodel>().transactions;
            return ListView.builder(
              reverse: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final isIncome =
                    transaction.transactionType == TransactionType.income;
                return ListTile(
                  title: Text(isIncome ? "Menabung" : "Penarikan"),
                  subtitle: Text("${transaction.createdAt}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(isIncome ? "+" : "-"),
                      Text("Rp. ${transaction.subtotal}"),
                    ],
                  ),
                );
              },
            );
          })
        ],
      ),
    );
  }
}
