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
      "title": "Bagaimana jika lupa kata sandi ?",
      "body":
          """
      Untuk reset kata sandi, terdapat pada saat masuk aplikasi.
        1.Klik Lupa Password
        2.Isi alamat email anda
        3.Klik Reset Password
        4.Email akan dikirimkan kepada anda, cek email secara berkala
        5.Klik link untuk mengubah kata sandi
        6.Masukkan kata sandi baru
        7.Akun dapat digunakan kembali.
      """,
    },
    {
      "title": "Tidak bisa tarik saldo, apa yang harus saya lakukan?",
      "body":
          """
Tarik saldo hanya bisa dilakukan jika sudah melakukan verifikasi akun di menu Profile.
    """
    },
    {
      "title": "Bagaimana cara mencairkan tabungan sampah?",
      "body":
          """
Berikut adalah cara untuk mencairkan tabungan sampah :
  1.Klik tombol Tarik Saldo pada menu Saldo Anda
  2.Masukkan nominal saldo yang akan ditarik
  3.Pilih “Metode Penarikan”  *(Cash dan Transfer)
  4. Lalu klik “Lakukan Penarikan”
*untuk metode cash, dana yang dicairkan akan dititipkan ke petugas saat jadwal penimbangan bank sampah
*untuk metode transfer, umumnya membutuhkan waktu 1x24 jam sampai dana masuk ke rekening nasabah
      """
    },
    {
      "title": "Bagaimana cara menambahkan saldo?",
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
