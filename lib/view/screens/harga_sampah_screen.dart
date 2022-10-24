import 'package:flutter/material.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';

class HargaSampahScreen extends StatelessWidget {
  const HargaSampahScreen({super.key});

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
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  color: hexToColor('#F0F6DC'),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Sampah'),
                        Text('Rp. 1000/kg'),
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
