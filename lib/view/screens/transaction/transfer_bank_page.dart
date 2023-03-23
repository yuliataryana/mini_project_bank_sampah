import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';
import 'package:mini_project_bank_sampah/model/transfer_request.dart';
import 'package:mini_project_bank_sampah/view/screens/success_screen.dart';
import 'package:mini_project_bank_sampah/viewmodel/main_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../common/overlay_manager.dart';

class TransferBankPage extends StatelessWidget {
  const TransferBankPage({super.key, required this.amount});
  final int amount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor("#F5F5F5"),
      appBar: AppBar(
        title: const Text("Transfer Bank"),
        elevation: 0,
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              // minimum withdraw is 50k
              if (amount < 50000) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Jumlah saldo minimal 50.000"),
                  ),
                );

                return;
              }
              Navigator.of(context)
                  .pushNamed("/widthdraw/bank-transfer/new", arguments: amount);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              color: hexToColor("#F5F5F5"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                      "https://tfkfnpwounbbwljvzusl.supabase.co/storage/v1/object/public/raw.assets/101-1016890_icon-bank-logo-png-transparent-png-removebg-preview%201.png"),
                  const Text(
                    "Tambah Rekening Baru",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 10,
            color: Color.fromARGB(255, 178, 178, 178),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Akun Bank yang tersimpan"),
          ),
          const Divider(
            thickness: 2,
          ),
          Builder(builder: (ctx) {
            final bankAccounts = context.watch<MainViewmodel>().bankAccounts;
            if (bankAccounts.isEmpty) {
              return const Center(
                child: Text("Tidak ada akun bank yang tersimpan"),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: bankAccounts.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  onTap: () async {
                    // minimum withdraw is 50k
                    if (amount < 50000) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Jumlah saldo minimal 50.000"),
                        ),
                      );

                      return;
                    }

                    try {
                      OverlayManager().showOverlay(
                        context,
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      final request = TransferBankRequest.fromBankAccount(
                        amount: amount,
                        idBankAccount: bankAccounts[index].idBankAccount,
                      );
                      await context
                          .read<MainViewmodel>()
                          .processBankWidthdraw(request);
                      OverlayManager().hideOverlay();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Berhasil"),
                        ),
                      );
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (_, anim, anim2) {
                          return ScaleTransition(
                            scale: anim,
                            child: const SuccessScreen(),
                          );
                        },
                        barrierDismissible: true,
                        barrierLabel: '',
                        transitionDuration: const Duration(milliseconds: 200),
                      );
                    } catch (e) {
                      OverlayManager().hideOverlay();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Permintaan gagal diproses, Silahkan coba beberapa saat lagi"),
                        ),
                      );
                    }
                  },
                  title: Text("${bankAccounts[index].bankName}"),
                  subtitle: Text(bankAccounts[index].accountNumber),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
            );
          })
        ],
      ),
    );
  }
}
