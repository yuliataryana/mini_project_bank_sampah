import 'package:flutter/material.dart';
import 'package:mini_project_bank_sampah/model/user_profile.dart';
import 'package:mini_project_bank_sampah/viewmodel/auth_viewmodel.dart';
import 'package:mini_project_bank_sampah/viewmodel/main_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../common/utils.dart';

class BalanceInfoCard extends StatelessWidget {
  const BalanceInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final balance = context.watch<MainViewmodel>().balance;
    final UserProfile? user = context.watch<AuthViewmodel>().userProfile;
    return Card(
      color: hexToColor("#F0F6DC"),
      child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.account_balance_wallet),
                Text(
                  "Saldo Anda",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rp. ${balance.toStringAsFixed(2)}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  user?.username ?? "-",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "BSS-0001011-PJ05",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ]),
              Row(
                children: [
                  Image.asset(
                    "assets/logo_sahaja.png",
                    width: 36,
                  ),
                  Text(
                    "Bank Sampah\nSahaja".toUpperCase(),
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
