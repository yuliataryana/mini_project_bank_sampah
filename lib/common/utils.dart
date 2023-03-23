import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mini_project_bank_sampah/model/transaction.dart';
import 'package:mini_project_bank_sampah/model/waste_category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//hex to color
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

// generator for material color swatch
// https://material.io/resources/color/#!/?view.left=0&view.right=0&primary.color=FF5722
// https://api.flutter.dev/flutter/material/MaterialColor-class.html
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final r = color.red, g = color.green, b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

const dummyItems = [
  {
    "image": "assets/botol_plastik.png",
    "name": "Botol plastik",
    "price": 1000,
  },
  {
    "image": "assets/botol_kaca.png",
    "name": "Botol Kaca",
    "price": 6000,
  },
  {
    "image": "assets/kaleng.png",
    "name": "Botol Kaleng",
    "price": 4000,
  },
  {
    "image": "assets/galon.png",
    "name": "Galon",
    "price": 8000,
  },
  {
    "image": "assets/kardus.png",
    "name": "Kardus",
    "price": 5000,
  },
  {
    "image": "assets/elektronik.png",
    "name": "Elektronik",
    "price": 10000,
  },
];

// [
//     {
//         "id_waste": 1,
//         "created_at": "2023-03-07T03:51:28.28344+00:00",
//         "waste_name": "ac",
//         "waste_price": "10000",
//         "image_url": "https://tfkfnpwounbbwljvzusl.supabase.co/storage/v1/object/public/raw.assets/ac.jpg"
//     }
// ]

final dummyWasteCategories = [
  {
    "id_waste": 1,
    "created_at": "2023-03-07T03:51:28.28344+00:00",
    "waste_name": "ac",
    "waste_price": "10000",
    "image_url":
        "https://tfkfnpwounbbwljvzusl.supabase.co/storage/v1/object/public/raw.assets/ac.jpg"
  },
  {
    "id_waste": 2,
    "created_at": "2023-03-07T03:51:28.28344+00:00",
    "waste_name": "botol plastik",
    "waste_price": "10000",
    "image_url":
        "https://tfkfnpwounbbwljvzusl.supabase.co/storage/v1/object/public/raw.assets/botol_plastik.jpg"
  },
  {
    "id_waste": 3,
    "created_at": "2023-03-07T03:51:28.28344+00:00",
    "waste_name": "botol kaca",
    "waste_price": "10000",
    "image_url":
        "https://tfkfnpwounbbwljvzusl.supabase.co/storage/v1/object/public/raw.assets/botol_kaca.jpg"
  },
].map((e) => WasteCategory.fromJson(e)).toList();
final supabase = Supabase.instance.client;

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

extension DynamicExtension on dynamic {
  double asConcreteDouble() {
    if (this is int) {
      return this.toDouble();
    }
    if (this is double) {
      return this;
    }
    if (this is String) {
      return double.parse(this);
    }
    return 0;
  }
}

String monthName(int month) {
  switch (month) {
    case 1:
      return 'jan';
    case 2:
      return 'feb';
    case 3:
      return 'mar';
    case 4:
      return 'apr';
    case 5:
      return 'may';
    case 6:
      return 'jun';
    case 7:
      return 'jul';
    case 8:
      return 'aug';
    case 9:
      return 'sep';
    case 10:
      return 'oct';
    case 11:
      return 'nov';
    case 12:
      return 'dec';
    default:
      return 'jan';
  }
}

extension DoubleExt on double {
  double asConcreteDouble() => this;
}

extension DateExt on DateTime? {
  // format date string with format 20 feb 2021
  String get formattedDate {
    if (this == null) {
      return '';
    }
    final month = this!.month;
    final day = this!.day;
    final year = this!.year;
    return '$day ${monthName(month)} $year';
  }

  // format date string with format 11 Ferbuari 2023, 10.45 WIB
  String get formattedDateTime {
    if (this == null) {
      return '';
    }
    final month = this!.month;
    final day = this!.day;
    final year = this!.year;
    final hour = this!.hour;
    final minute = this!.minute;
    return '$day ${monthName(month)} $year, $hour.$minute WIB';
  }
}

Color generateColorFromString(String string) {
  final ascii = string.codeUnits;
  final color = int.parse(ascii.join().substring(0, 8), radix: 16);
  return Color(color);
}

extension StringExt on String {
  String get capitalize {
    // ignore: unnecessary_this
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  Color get genColor => generateColorFromString(this);
}

extension ListTransExt on List<Transaction> {
  int get balance {
    final trxs = map((element) {
      if (element.transactionType == TransactionType.income) {
        return element.subtotal;
      } else {
        return -element.subtotal;
      }
    }).toList();
    return isEmpty ? 0 : trxs.reduce((value, element) => value + element);
  }
}

// create article dummy
// - artikel 1
// Judul : Walikota Tangsel Meresmikan Bank Sampah dan Taman Baca Di Pakujaya
// imageurl : https://i.ibb.co/kyBd1t7/artikel1.jpg
// Link : https://gerbangbanten.co.id/walikota-tangsel-meresmikan-bank-sampah-dan-taman-baca-di-pakujaya/

// - artikel 2
// Judul : Tangerang Selatan Hasilkan 1000 Ton Sampah Setiap Hari
// imageurl : https://i.ibb.co/SvBg1wn/artikel2.jpg
// Link : https://www.tangerangraya.id/tangerang-raya/pr-1951583571/tangerang-selatan-hasilkan-1000-ton-sampah-setiap-hari

final articles = [
  {
    "id_article": 1,
    "created_at": "2023-03-07T03:51:28.28344+00:00",
    "title":
        "Walikota Tangsel Meresmikan Bank Sampah dan Taman Baca Di Pakujaya",
    "image_url": "https://i.ibb.co/kyBd1t7/artikel1.jpg",
    "link":
        "https://gerbangbanten.co.id/walikota-tangsel-meresmikan-bank-sampah-dan-taman-baca-di-pakujaya/"
  },
  {
    "id_article": 2,
    "created_at": "2023-03-07T03:51:28.28344+00:00",
    "title": "Tangerang Selatan Hasilkan 1000 Ton Sampah Setiap Hari",
    "image_url": "https://i.ibb.co/SvBg1wn/artikel2.jpg",
    "link":
        "https://www.tangerangraya.id/tangerang-raya/pr-1951583571/tangerang-selatan-hasilkan-1000-ton-sampah-setiap-hari"
  }
].map((e) => Article.fromJson(e)).toList();

class Article {
  final int idArticle;
  final DateTime createdAt;
  final String title;
  final String imageUrl;
  final String link;

  Article({
    required this.idArticle,
    required this.createdAt,
    required this.title,
    required this.imageUrl,
    required this.link,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        idArticle: json["id_article"],
        createdAt: DateTime.parse(json["created_at"]),
        title: json["title"],
        imageUrl: json["image_url"],
        link: json["link"],
      );
}
// galeries from
// 1 : https://i.ibb.co/XCf1FjZ/gambar1.jpg
// 2 : https://i.ibb.co/KqzRVJ9/gambar2.jpg
// 3 : https://i.ibb.co/MZJZQ8v/gambar3.jpg
// 4 : https://i.ibb.co/WBBSbbY/gambar4.jpg
// 5 : https://i.ibb.co/NTbKpfY/gambar5.jpg
// 6 : https://i.ibb.co/nfkFSg2/gambar6.jpg
// 7 : https://i.ibb.co/7yvp7b7/gambar7.jpg

final galleries = [
  {
    "id_gallery": 1,
    "created_at": "2023-03-07T03:51:28.28344+00:00",
    "image_url": "https://i.ibb.co/XCf1FjZ/gambar1.jpg",
  },
  {
    "id_gallery": 2,
    "created_at": "2023-03-07T03:51:28.28344+00:00",
    "image_url": "https://i.ibb.co/KqzRVJ9/gambar2.jpg",
  },
  {
    "id_gallery": 3,
    "created_at": "2023-03-07T03:51:28.28344+00:00",
    "image_url": "https://i.ibb.co/MZJZQ8v/gambar3.jpg",
  },
  {
    "id_gallery": 4,
    "created_at": "2023-03-07T03:51:28.28344+00:00",
    "image_url": "https://i.ibb.co/WBBSbbY/gambar4.jpg",
  },
  {
    "id_gallery": 5,
    "created_at": "2023-03-07T03:51:28.28344+00:00",
    "image_url": "https://i.ibb.co/NTbKpfY/gambar5.jpg",
  },
  {
    "id_gallery": 6,
    "created_at": "2023-03-07T03:51:28.28344+00:00",
    "image_url": "https://i.ibb.co/nfkFSg2/gambar6.jpg",
  },
  {
    "id_gallery": 7,
    "created_at": "2023-03-07T03:51:28.28344+00:00",
    "image_url": "https://i.ibb.co/7yvp7b7/gambar7.jpg",
  },
];
