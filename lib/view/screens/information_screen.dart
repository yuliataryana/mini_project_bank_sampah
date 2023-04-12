import 'package:flutter/material.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  late final TextEditingController _searchController;
  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  final faqs = [
    
    {
      "title": "Tidak bisa Login setelah registrasi, apa yang harus saya lakukan?",
      "body":
          """
Login hanya bisa dilakukan jika sudah melakukan verifikasi email, cek email secara berkala.
    """
    },
    {
      "title": "Bagaimana cara mencairkan tabungan sampah?",
      "body":
          """
Berikut adalah cara untuk mencairkan tabungan sampah :
  1.Klik tombol Tarik Saldo pada menu Saldo Anda
  2.Masukkan nominal saldo yang akan ditarik
  3.Pilih “Metode Penarikan”  *(Cash)
  4. Lalu penarikan dilakukan
*untuk metode cash, dana yang dicairkan akan dititipkan ke petugas saat jadwal penimbangan bank sampah
      """
    },
    {
      "title": "Bagaimana cara menimbang sampah?",
      "body":
          """
Semua proses penimbangan dilakukan oleh petugas saat jadwal penimbangan bank sampah
      """
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi'),
        elevation: 0,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text(
                  'Hai, Butuh Bantuan?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari di sini',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                )
              ],
            ),
          ),
          AnimatedBuilder(
              animation: _searchController,
              builder: (context, child) {
// create listview of expandable listtile
                final filteredFaqs = faqs.where((faq) {
                  final title = faq['title'] ?? "";
                  final body = faq['body'] ?? "";
                  return title.contains(_searchController.text) ||
                      body.contains(_searchController.text);
                }).toList();

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(16),
                    elevation: 8,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredFaqs.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            title: Text(filteredFaqs[index]['title'] ?? ""),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(filteredFaqs[index]['body'] ?? ""),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
