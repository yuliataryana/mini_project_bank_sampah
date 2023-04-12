import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';
import 'package:mini_project_bank_sampah/model/detail_transaction.dart';
import 'package:mini_project_bank_sampah/viewmodel/auth_viewmodel.dart';
import 'package:mini_project_bank_sampah/viewmodel/main_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../model/transaction.dart';

class HistoryPage extends StatelessWidget {
  // const HistoryPage({super.key});

  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wasteCategories = context.watch<MainViewmodel>().itemsType;
    final profile = context.watch<AuthViewmodel>().userProfile;
    final transactionHistory = context.watch<MainViewmodel>().transactions;
    final bankAccounts = context.watch<MainViewmodel>().bankAccounts;
    return Scaffold(
      appBar: AppBar(
        title: profile?.role != "admin"
            ? const Text('Riwayat')
            : const Text('Pending Transaction'),
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: transactionHistory.length,
          itemBuilder: (context, index) {
            final transaction = transactionHistory[index];
            final isIncome =
                transaction.transactionType == TransactionType.income;

            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/transaction-detail",
                      arguments: transaction,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  isIncome
                                      ? "https://tfkfnpwounbbwljvzusl.supabase.co/storage/v1/object/public/raw.assets/shopping_bag.png"
                                      : "https://tfkfnpwounbbwljvzusl.supabase.co/storage/v1/object/public/raw.assets/pngtree-cash-withdrawal-icon-in-trendy-style-isolated-background-png-image_1538665-removebg-preview%201.png",
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                // show created at with format 16 feb 2023
                                Text(
                                  transaction.createdAt?.formattedDate ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ],
                            ),
                            Builder(
                              builder: (context) {
                                switch (transaction.status) {
                                  case TransactionStatus.pending:
                                    return Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "Pending",
                                        style: TextStyle(
                                          color: Colors.yellow[600],
                                          fontWeight: FontWeight.w200,
                                          fontSize: 8,
                                        ),
                                      ),
                                    );
                                  case TransactionStatus.success:
                                    return Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "Success",
                                        style: TextStyle(
                                          color: Colors.green[600],
                                          fontWeight: FontWeight.w200,
                                          fontSize: 8,
                                        ),
                                      ),
                                    );
                                  case TransactionStatus.failed:
                                    return Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "Failed",
                                        style: TextStyle(
                                          color: Colors.red[600],
                                          fontWeight: FontWeight.w200,
                                          fontSize: 8,
                                        ),
                                      ),
                                    );
                                }
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Builder(builder: (ctx) {
                          if (isIncome) {
                            final detailTransaction = transaction
                                .detailTransaction
                                .cast<DetailIncomeTransaction>();
                            final detailFirstItem = wasteCategories.firstWhere(
                              (element) =>
                                  element.idWaste ==
                                  detailTransaction.first.idWaste,
                            );
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      detailFirstItem.imageUrl,
                                      width: 80,
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          detailFirstItem.wasteName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                            "${detailTransaction.first.qty} Kg"),
                                      ],
                                    ),
                                  ],
                                ),
                                detailTransaction.length > 1
                                    ? Row(
                                        children: [
                                          Text(
                                              "+${detailTransaction.length - 1} Product lainnya"),
                                        ],
                                      )
                                    : const SizedBox(),
                                Row(
                                  children: [
                                    const Text("Total Harga"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Rp. ${transaction.subtotal.toInt()}",
                                      // "Rp. ${(detailTransaction.first.qty * detailFirstItem.wastePrice.toInt())}",
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            final detailTransaction = transaction
                                .detailTransaction
                                .cast<DetailOutcomeTransaction>();
                            Map<String, dynamic> map = {};
                            if (detailTransaction.isNotEmpty) {
                              map = detailTransaction.first.method;

                              if (map["idBankAccount"] != null) {
                                final bankAccount = bankAccounts.firstWhere(
                                  (element) =>
                                      element.idBankAccount ==
                                      map["idBankAccount"],
                                );
                                map["bankName"] = bankAccount.bankName;
                                map["accountNumber"] =
                                    bankAccount.accountNumber;
                                map["accountHolder"] =
                                    bankAccount.accountHolder;
                              }
                            }

                            print(detailTransaction);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("Nasabah : ${profile?.username}"),
                                  ],
                                ),
                                // jumlah penarikan
                                Row(
                                  children: [
                                    Text(
                                      "Jumlah Penarikan : Rp. ${transaction.subtotal.toInt()}",
                                    ),
                                  ],
                                ),
                                // metode penarikan

                                Row(
                                  children: [
                                    Text("Metode Penarikan : ${map["method"]}"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Rekening Bank : "),
                                    map["method"] == "bank"
                                        ? Text(
                                            "${map["bankName"]} (${map["accountNumber"]})")
                                        : const Text("-")
                                  ],
                                ),
                              ],
                            );
                          }
                        })
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
