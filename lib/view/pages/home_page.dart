import 'package:flutter/material.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';
import 'package:mini_project_bank_sampah/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widget/balance_info_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const Icon(Icons.group),
        title: Builder(builder: (context) {
          final profile = context.watch<AuthViewmodel>().userProfile;
          if (profile?.role == "admin") return const Text("Admin");
          return const Text("Nasabah");
        }),
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
                Builder(builder: (context) {
                  final profile = context.watch<AuthViewmodel>().userProfile;
                  if (profile?.role == "admin") return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/profile/balance");
                      },
                      child: const BalanceInfoCard(),
                    ),
                  );
                }),
                Builder(builder: (context) {
                  final profile = context.watch<AuthViewmodel>().userProfile;
                  final menus = profile?.role == "admin"
                      ? [
                          {
                            "image": "tabung_sampah.png",
                            "title": "Tabung Sampah",
                            "onClick": () {
                              Navigator.of(context).pushNamed(
                                '/trash_bank',
                                arguments: "admin",
                              );
                            }
                          },
                          {
                            "image": "harga_sampah.png",
                            "title": "harga sampah",
                            "onClick": () {
                              Navigator.of(context).pushNamed("/price_list");
                            }
                          },
                          {
                            "image": "nasabah.png",
                            "title": "Data Nasabah",
                            "onClick": () {
                              Navigator.of(context)
                                  .pushNamed("/admin/customers");
                            }
                          },
                        ]
                      : [
                          {
                            "image": "tabung_sampah.png",
                            "title": "Tabung Sampah",
                            "onClick": () {
                              Navigator.of(context).pushNamed(
                                '/trash_bank',
                              );
                            }
                          },
                          {
                            "image": "harga_sampah.png",
                            "title": "harga sampah",
                            "onClick": () {
                              Navigator.of(context).pushNamed("/price_list");
                            }
                          },
                          {
                            "image": "carts.png",
                            "title": "Keranjang",
                            "onClick": () {
                              Navigator.of(context).pushNamed("/cart");
                            }
                          },
                          {
                            "image": "informasi.png",
                            "title": "Informasi",
                            "onClick": () {
                              Navigator.of(context).pushNamed("/information");
                            }
                          }
                        ];
                  return Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Row(
                      children: menus
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
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(),
                                            Image.asset(
                                              "assets/${e["image"]}",
                                              width: 36,
                                            ),
                                            Flexible(
                                              child: Text(
                                                e["title"].toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  );
                })
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
                      "Berita Terbaru",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: articles.length,
                    itemBuilder: (ctx, index) {
                      final article = articles[index];
                      return InkWell(
                        onTap: () async {
                          // url launcer launch url
                          try {
                            final res = await launchUrl (
                                Uri.parse(article.link),
                                mode: LaunchMode.externalApplication);
                            debugPrint("$res ${article.link}");
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 250,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    article.title,
                                  ),
                                  Expanded(
                                    child: Image.network(
                                      article.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Galleri",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: galleries.length,
                    itemBuilder: (ctx, index) {
                      final article = galleries[index];
                      return InkWell(
                        onTap: () async {
                          // url launcer launch url
                          // try {
                          //   final res = await launchUrl(
                          //       Uri.dataFromString(article.link));
                          //   debugPrint("$res ${article.link}");
                          // } catch (e) {
                          //   debugPrint(e.toString());
                          // }
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 250,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // Text(
                                  //   article.title,
                                  // ),
                                  Expanded(
                                    child: Image.network(
                                      article["image_url"].toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   height: 100,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     itemCount: galleries.length,
                //     itemBuilder: (ctx, index) {
                //       final img = galleries[index];
                //       return InkWell(
                //         onTap: () {
                //           // url launcer launch url
                //           // try {
                //           //   launchUrl(Uri.dataFromString(article.link));
                //           // } catch (e) {
                //           //   debugPrint(e.toString());
                //           // }
                //         },
                //         child: Card(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               // Row(
                //               //   children: [
                //               //     Expanded(
                //               //       child: Padding(
                //               //         padding: const EdgeInsets.only(left: 16.0),
                //               //         child: Text(
                //               //           article.title,
                //               //           style: Theme.of(context)
                //               //               .textTheme
                //               //               .titleLarge
                //               //               ?.copyWith(
                //               //                 fontWeight: FontWeight.bold,
                //               //               ),
                //               //         ),
                //               //       ),
                //               //     ),
                //               //   ],
                //               // ),

                //               // Row(
                //               //   children: [
                //               //     Expanded(
                //               // child:
                //               Image.network(
                //                 img["image_url"].toString(),
                //                 width: double.infinity,
                //               ),
                //               //     ),
                //               //   ],
                //               // )
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
