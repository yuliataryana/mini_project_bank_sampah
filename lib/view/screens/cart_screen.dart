import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mini_project_bank_sampah/common/overlay_manager.dart';
import 'package:mini_project_bank_sampah/model/cart_item.dart';
import 'package:mini_project_bank_sampah/service/transaction_service.dart';
import 'package:mini_project_bank_sampah/view/screens/success_screen.dart';
import 'package:mini_project_bank_sampah/viewmodel/main_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../model/transaction.dart';
import '../widget/add_item_dialog.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color(0xFFF0F6DC),
        cardColor: const Color(0xFFF0F6DC),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Keranjang'),
        ),
        body: Builder(
          builder: (context) {
            final cart = context.watch<MainViewmodel>().carts;

            // return Text(cart.toString());
            return ListView.builder(
              itemCount: cart.length + 1,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                if (index == cart.length) {
                  // create  outlined add button
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, "/trash_bank"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF0F6DC),
                        foregroundColor: Colors.green,
                        side: const BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text("Tambah Sampah"),
                    ),
                  );
                }
                final item = cart[index];
                return Card(
                  elevation: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Image.network(
                          item.imageUrl,
                          width: 100,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  item.wasteName.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text("jumlah : ${item.qty.toString()}Kg"),
                                Text(
                                    "harga : Rp.${item.wastePrice.toString()}"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        // show dialog
                                        final qty = double.tryParse(
                                            (await showGeneralDialog<String>(
                                                  context: context,
                                                  pageBuilder:
                                                      (_, anim, anim2) {
                                                    return ScaleTransition(
                                                      scale: anim,
                                                      child: AddItemDialog(
                                                        submitLabel: "Ubah",
                                                        initialValue: item.qty,
                                                        child: Image.network(
                                                          item.imageUrl,
                                                          width: 200,
                                                          // height: 100,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  barrierDismissible: true,
                                                  barrierLabel: '',
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                )) ??
                                                "0");
                                        if (qty != null || qty! > 0) {
                                          final newItem = CartItem(
                                            idWaste: item.idWaste,
                                            wasteName: item.wasteName,
                                            wastePrice: item.wastePrice,
                                            imageUrl: item.imageUrl,
                                            qty: qty,
                                          );
                                          context
                                              .read<MainViewmodel>()
                                              .updateCartItem(newItem, qty);
                                        }
                                      },
                                      child: const Text("Ubah"),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<MainViewmodel>()
                                            .removeCartItem(item);
                                      },
                                      child: const Text("Hapus"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          // height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Harga Total",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Rp.${context.watch<MainViewmodel>().totalPrice}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (context.read<MainViewmodel>().totalPrice < 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Keranjang masih kosong"),
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
                            await context
                                .read<MainViewmodel>()
                                .processSavingTransaction();
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
                              transitionDuration:
                                  const Duration(milliseconds: 200),
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
                        child: const Text("Tukarkan"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
