import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/overlay_manager.dart';
import '../../../viewmodel/main_viewmodel.dart';
import '../success_screen.dart';

class WidthDrawScreen extends StatefulWidget {
  const WidthDrawScreen({super.key});

  @override
  State<WidthDrawScreen> createState() => _WidthDrawScreenState();
}

class _WidthDrawScreenState extends State<WidthDrawScreen> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarik Saldo"),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Jumlah Saldo",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Masukkan jumlah saldo yang akan ditarik",
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            title: const Text("Cash"),
            onTap: _processCashWithdraw,
          ),
          const Divider(
            thickness: 2,
          ),
          ListTile(
            title: Text("Bank Transfer"),
            trailing: Icon(Icons.chevron_right_outlined),
            onTap: () {
              if (_controller.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Jumlah saldo tidak boleh kosong"),
                  ),
                );

                return;
              }
              final amount = int.tryParse(_controller.text) ?? 0;
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
                  .pushNamed("/widthdraw/bank-transfer", arguments: amount);
            },
          ),
          const Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }

  Future<void> _processCashWithdraw() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Jumlah saldo tidak boleh kosong"),
        ),
      );

      return;
    }
    final amount = int.tryParse(_controller.text) ?? 0;
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
      await context.read<MainViewmodel>().processCashWidthdraw(amount);
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
