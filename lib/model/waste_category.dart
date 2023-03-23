// [
//     {
//         "id_waste": 1,
//         "created_at": "2023-03-07T03:51:28.28344+00:00",
//         "waste_name": "ac",
//         "waste_price": 10000,
//         "image_url": "https://tfkfnpwounbbwljvzusl.supabase.co/storage/v1/object/public/raw.assets/ac.jpg"
//     }
// ]

class WasteCategory {
  WasteCategory({
    this.idWaste,
    this.createdAt,
    required this.wasteName,
    required this.wastePrice,
    required imageUrl,
  }) : _imageUrl = imageUrl;

  int? idWaste;
  DateTime? createdAt;
  String wasteName;
  int wastePrice;
  String _imageUrl;

  String get imageUrl {
    if (_imageUrl.contains('https')) {
      return _imageUrl;
    }
    return 'https://tfkfnpwounbbwljvzusl.supabase.co/storage/v1/object/public/$_imageUrl';
  }

  factory WasteCategory.fromJson(Map<String, dynamic> json) {
    print(json);
    return WasteCategory(
      idWaste: json["id_waste"],
      createdAt: DateTime.parse(json["created_at"]),
      wasteName: json["waste_name"],
      wastePrice: json["waste_price"],
      imageUrl: json["image_url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id_waste": idWaste,
        "created_at": createdAt?.toIso8601String(),
        "waste_name": wasteName,
        "waste_price": wastePrice,
        "image_url": imageUrl,
      };
  // copywith
  WasteCategory copyWith({
    int? idWaste,
    DateTime? createdAt,
    String? wasteName,
    int? wastePrice,
    String? imageUrl,
  }) {
    return WasteCategory(
      idWaste: idWaste ?? this.idWaste,
      createdAt: createdAt ?? this.createdAt,
      wasteName: wasteName ?? this.wasteName,
      wastePrice: wastePrice ?? this.wastePrice,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
