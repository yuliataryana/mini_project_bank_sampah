import 'package:flutter/material.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor('#F0F6DC'),
      appBar: AppBar(
        elevation: 0,
        leading: const Icon(Icons.group),
        title: const Text("Nasabah"),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //card for account short info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: hexToColor("#F0F6DC"),
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.account_balance_wallet),
                                  Text(
                                    "Saldo Anda",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Rp. 100.000",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Yulia Taryana",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "BSS-0001011-PJ05",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ]),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/logo_sahaja.png",
                                  width: 36,
                                ),
                                Text(
                                  "Bank Sampah\nSahaja".toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Row(
                      children: [
                    {
                      "image": "tabung_sampah.png",
                      "title": "Tabung Sampah",
                      "onClick": () {
                        Navigator.of(context).pushNamed('/trash_bank');
                      }
                    },
                    {
                      "image": "harga_sampah.png",
                      "title": "harga sampah",
                      "onClick": () {
                        Navigator.of(context).pushNamed("/price_list");
                      }
                    },
                    {"image": "cari_sampah.png", 
                    "title": "cek sampah"},
                    {
                      "image": "informasi.png",
                      "title": "Informasi",
                    }
                  ]
                          .map((e) => Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: InkWell(
                                    onTap: (e["onClick"] as void Function()?),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/${e["image"]}",
                                                width: 30,
                                              ),
                                              // const Spacer(),
                                              Flexible(
                                                child: Text(
                                                  e["title"].toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      ?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              // const Spacer(),
                                            ],
                                          ),
                                        
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList()),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "Media",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ...[
                  {
                    "title": "Article",
                    "image": "artikel.png",
                    "description":
                        "Pengelolaan Bank Sampah Wujudkan Aksi Nyata Masyarakat Peduli Sampah"
                  },
                  {
                    "title": "Galeri",
                    "image": "galeri.png",
                  }
                ].map(
                  (e) => Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      e["title"] ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                        e["description"] ?? "",
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              // child:
                              Image.asset(
                                "assets/${e["image"]}",
                                width: double.infinity,
                              ),
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
