// [
//     {
//         "id_waste": 1,
//         "created_at": "2023-03-07T03:51:28.28344+00:00",
//         "waste_name": "ac",
//         "waste_price": 10000,
//         "image_url": "https://tfkfnpwounbbwljvzusl.supabase.co/storage/v1/object/public/raw.assets/ac.jpg"
//     }
// ]

class CartItem {
  CartItem({
    required this.qty,
    this.idWaste,
    this.createdAt,
    required this.wasteName,
    required this.wastePrice,
    required this.imageUrl,
  });

  int? idWaste;
  DateTime? createdAt;
  String wasteName;
  int wastePrice;
  String imageUrl;
  double qty;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        qty: json["qty"] ?? 1.0,
        idWaste: json["id_waste"],
        createdAt: DateTime.parse(json["created_at"]),
        wasteName: json["waste_name"],
        wastePrice: json["waste_price"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id_waste": idWaste,
        "created_at": createdAt?.toIso8601String(),
        "waste_name": wasteName,
        "waste_price": wastePrice,
        "image_url": imageUrl,
      };
}
