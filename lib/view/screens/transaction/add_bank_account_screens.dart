import 'package:flutter/material.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';
import 'package:mini_project_bank_sampah/model/transfer_request.dart';
import 'package:provider/provider.dart';

import '../../../common/overlay_manager.dart';
import '../../../viewmodel/main_viewmodel.dart';
import '../success_screen.dart';

class AddBankAccount extends StatefulWidget {
  const AddBankAccount({super.key, required this.amount});
  final int amount;

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  late final TextEditingController _holderController,
      _accountNumberController,
      _bankNameController;
  bool isTemporaryBankAccount = false;
  @override
  void initState() {
    _holderController = TextEditingController();
    _accountNumberController = TextEditingController();
    _bankNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _holderController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor("#F5F5F5"),
      appBar: AppBar(
        title: const Text("Transfer Bank"),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Nama Pemilik",
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.end,
                        controller: _holderController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Masukkan nama pemilik rekening",
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                Row(
                  children: [
                    const Text(
                      "Nama Bank",
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.end,
                        controller: _bankNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Masukkan nama bank",
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                Row(
                  children: [
                    const Text(
                      "Nomor Rekening",
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.end,
                        controller: _accountNumberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Masukkan nomor rekening",
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Simpan Rekening"),
                    Switch(
                      value: !isTemporaryBankAccount,
                      onChanged: (value) {
                        setState(() {
                          isTemporaryBankAccount = !value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
              ],
            ),
          ),
        ],
      ),
      // proses penarikan button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _processWidthdraw,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                  child: Text(" Proses Penarikan "),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processWidthdraw() async {
    // minimum withdraw is 50k
    if (widget.amount < 50000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Jumlah saldo minimal 50.000"),
        ),
      );

      return;
    }
    // validate all form
    if (_holderController.text.isEmpty ||
        _accountNumberController.text.isEmpty ||
        _bankNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon lengkapi semua form"),
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
      final request = isTemporaryBankAccount
          ? TransferBankRequest.instantTransfer(
              amount: widget.amount,
              bankName: _bankNameController.text,
              accountNumber: _accountNumberController.text,
              accountHolder: _holderController.text)
          : TransferBankRequest.fromNewBankAccount(
              amount: widget.amount,
              bankName: _bankNameController.text,
              accountNumber: _accountNumberController.text,
              accountHolder: _holderController.text,
            );
      await context.read<MainViewmodel>().processBankWidthdraw(request);
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
  }
}
