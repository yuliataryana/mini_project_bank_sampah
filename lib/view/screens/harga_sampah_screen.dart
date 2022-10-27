import 'package:flutter/material.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';

class HargaSampahScreen extends StatelessWidget {
   HargaSampahScreen({super.key});
  // ignore: non_constant_identifier_names
  final List<Map<String, dynamic>> ListHarga = [
    {
      "Nama" : "Botol Plastik",
      "Harga" : 3000,
    },
    {
      "Nama" : "Botol Kaca",
      "Harga" : 2000,
    },
    {
      "Nama" : "Botol Kaleng",
      "Harga" : 3000,
    },
    {
      "Nama" : "Galon",
      "Harga" : 5000,
    },
    {
      "Nama" : "Kardus",
      "Harga" : 4000,
    },
    {
      "Nama" : "Kertas",
      "Harga" : 3000,
    },
    {
      "Nama" : "Buku Bekas",
      "Harga" : 3000,
    },
    {
      "Nama" : "Elektronik",
      "Harga" : 8000,
    },
    {
      "Nama" : "Tutup Botol",
      "Harga" : 3000
    },
    {
      "Nama" : "Plastik",
      "Harga" : 2000,
    },
    {
      "Nama" : "Besi",
      "Harga" : 10000,
    },
    {
      "Nama" : "Perabot Bekas",
      "Harga" : 4000,
    },
  ];


  @override
  Widget build(BuildContext context) {
    // create scaffold page with appbar and search bar in body with list of listtile
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
            child: ListView.builder(
              itemCount: ListHarga.length,
              itemBuilder: (context, index) {
                final list = ListHarga[index];
                return Card(
                  color: hexToColor('#F0F6DC'),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${list["Nama"]}'),
                        Text('Rp ${list["Harga"]} /kg'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
