import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';
import 'package:mini_project_bank_sampah/model/detail_nasabah.dart';
import 'package:mini_project_bank_sampah/service/admin_service.dart';

import '../../../model/transaction.dart';

class DetailCustomer extends StatelessWidget {
  const DetailCustomer({super.key, required this.userid});
  final String userid;

  @override
  Widget build(BuildContext context) {
    print(userid);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Data Nasabah"),
      ),
      body: FutureBuilder<DetailNasabah>(
          future: AdminService().getDetailNasabah(userid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final user = snapshot.data;
            print(user);
            return ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Profile",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: user?.userProfile.photoProfile != null
                                  ? CircleAvatar(
                                      radius: 32,
                                      backgroundImage: NetworkImage(
                                        user!.userProfile.photoProfile!,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 32,
                                      child: Text(
                                        user!.userProfile.username![0]
                                            .toUpperCase(),
                                      ),
                                    ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nama : ${user.userProfile.username ?? "-"}",
                                ),
                                Text(
                                  "email : ${user.user.email ?? "-"}",
                                ),
                                Text(
                                  "phone : ${user.userProfile.phone ?? "-"}",
                                ),
                                Text(
                                  "Alamat : ${user.userProfile.address ?? "-"}",
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                // saldo
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Saldo",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                "Saldo Terakhir Nasabah : Rp. ${user.transaction.balance}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(
                  thickness: 2,
                ),
                // saldo
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Riwayat Transaksi",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                user.transaction.isEmpty
                    ? Text("Belum ada Riwayat Transaksi")
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: user.transaction.length,
                        itemBuilder: (context, index) {
                          final transaction = user.transaction[index];
                          final isIncome = transaction.transactionType ==
                              TransactionType.income;
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
                      ),
              ],
            );
          }),
    );
  }
}
