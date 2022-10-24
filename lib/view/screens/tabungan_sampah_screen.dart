import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/utils.dart';

class TabunganSampahScreen extends StatefulWidget {
  const TabunganSampahScreen({super.key});

  @override
  State<TabunganSampahScreen> createState() => _TabunganSampahScreenState();
}

class _TabunganSampahScreenState extends State<TabunganSampahScreen> {
  int itemCLicked = 0;
  final items = const [
    {
      "image": "assets/botol_plastik.png",
      "title": "Botol plastik",
    },
    {
      "image": "assets/botol_kaca.png",
      "title": "Botol Kaca",
    },
    {
      "image": "assets/kaleng.png",
      "title": "Botol Kaleng",
    },
    {
      "image": "assets/galon.png",
      "title": "Galon",
    },
    {
      "image": "assets/kardus.png",
      "title": "Kardus",
    },
    {
      "image": "assets/elektronik.png",
      "title": "Elektronik",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // create scaffold page with appbar and search bar in body with gridview

    return Scaffold(
      backgroundColor: hexToColor('#F0F6DC'),
      appBar: AppBar(
        title: const Text('Tabung Sampah'),
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
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () {
                      itemCLicked++;
                      setState(() {});
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
                            Expanded(child: Image.asset('${item['image']}')),
                            Text('${item["title"]}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: hexToColor("#7A9D30"),
          ),
          child: Text(
            "Keranjang ($itemCLicked)",
            textAlign: TextAlign.center,
            style:
                GoogleFonts.livvic(color: hexToColor("#F0F6DC"), fontSize: 18),
          ),
        ),
      ),
    );
  }
}
