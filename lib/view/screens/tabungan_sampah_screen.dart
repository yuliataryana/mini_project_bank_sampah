import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project_bank_sampah/view/widget/add_item_dialog.dart';
import 'package:mini_project_bank_sampah/viewmodel/main_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../common/utils.dart';

class TabunganSampahScreen extends StatelessWidget {
  const TabunganSampahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // create scaffold page with appbar and search bar in body with gridview

    return Scaffold(
      backgroundColor: hexToColor('#F0F6DC'),
      appBar: AppBar(
        title: const Text('Harga Sampah'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Cari jenis sampah',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              final items = context.watch<MainViewmodel>().itemsType;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () async {
                        // add otem to cart with dialog
                        final qty =
                            double.tryParse((await showGeneralDialog<String>(
                                  context: context,
                                  pageBuilder: (_, anim, anim2) {
                                    return ScaleTransition(
                                      scale: anim,
                                      child: AddItemDialog(
                                        child: Image.network(
                                          item.imageUrl,
                                          width: 200,
                                          // height: 100,
                                        ),
                                      ),
                                    );
                                  },
                                )) ??
                                "");
                        if (qty != null || (qty ?? 0) > 0) {
                          context
                              .read<MainViewmodel>()
                              .addItemToCart(item, qty);
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Image.network(item.imageUrl)),
                              Text(item.wasteName),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, "/cart");
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: hexToColor("#7A9D30"),
          ),
          child: Builder(builder: (context) {
            final cart = context.watch<MainViewmodel>().carts;
            return Text(
              "Keranjang (${cart.length})",
              textAlign: TextAlign.center,
              style: GoogleFonts.livvic(
                color: hexToColor("#F0F6DC"),
                fontSize: 18,
              ),
            );
          }),
        ),
      ),
    );
  }
}
