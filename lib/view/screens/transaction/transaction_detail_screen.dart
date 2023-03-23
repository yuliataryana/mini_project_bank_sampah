import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';
import 'package:mini_project_bank_sampah/model/detail_transaction.dart';
import 'package:provider/provider.dart';

import '../../../model/transaction.dart';
import '../../../viewmodel/main_viewmodel.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.transaction});
  final Transaction transaction;

  List<DetailIncomeTransaction> get detailIncomeTransaction =>
      transaction.detailTransaction.cast<DetailIncomeTransaction>();

  @override
  Widget build(BuildContext context) {
    final wasteCategories = context.watch<MainViewmodel>().itemsType;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              // status transaksi
              Text(
                "Status Transaksi : Berhasil",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // status transaksi
              Text(
                "Tanggal Transaksi",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                transaction.createdAt.formattedDateTime,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const Divider(
            thickness: 2,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Card(
              child: Container(
                // padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Detail Tabungan",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (var detail in detailIncomeTransaction)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.network(
                                  wasteCategories
                                      .firstWhere((element) =>
                                          element.idWaste == detail.idWaste)
                                      .imageUrl,
                                  width: 80,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      wasteCategories
                                          .firstWhere((element) =>
                                              element.idWaste == detail.idWaste)
                                          .wasteName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("${detail.qty} Kg"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                  "Total Menabung(${detailIncomeTransaction.length} barang)"),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Rp. ${transaction.subtotal.toInt()}"
                                  // "Rp. ${(detailTransaction.first.qty * detailFirstItem.wastePrice.toInt())}",
                                  ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
