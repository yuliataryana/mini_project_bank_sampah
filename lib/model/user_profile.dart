// [
//     {
//         "userid": "def3a737-7c43-4362-9085-f27dfb79f3d5",
//         "created_at": "2023-03-08T23:28:29.224092+00:00",
//         "photo_profile": null,
//         "username": "yulia",
//         "address": null
//     }
// ]

class UserProfile {
  UserProfile(
      {this.userid,
      this.createdAt,
      this.photoProfile,
      this.username,
      this.address,
      this.role,
      this.phone});

  String? userid;
  DateTime? createdAt;
  String? photoProfile;
  String? username;
  String? address;
  String? role;
  String? phone;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userid: json["userid"],
        createdAt: DateTime.parse(json["created_at"]),
        photoProfile: json["photo_profile"],
        username: json["username"],
        address: json["address"],
        role: json["role"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "created_at": createdAt?.toIso8601String(),
        "photo_profile": photoProfile,
        "username": username,
        "address": address,
        "role": role,
        "phone": phone,
      };

  UserProfile copyWith({
    String? userid,
    DateTime? createdAt,
    String? photoProfile,
    String? username,
    String? address,
    String? role,
    String? phone,
  }) =>
      UserProfile(
        userid: userid ?? this.userid,
        createdAt: createdAt ?? this.createdAt,
        photoProfile: photoProfile ?? this.photoProfile,
        username: username ?? this.username,
        address: address ?? this.address,
        role: role ?? this.role,
        phone: phone ?? this.phone,
      );
}
