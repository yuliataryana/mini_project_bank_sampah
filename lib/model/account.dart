import 'dart:convert';

import 'package:hive/hive.dart';
part 'account.g.dart';

@HiveType(typeId: 0)
class Account {
  @HiveField(0)
  int uid;
  @HiveField(1)
  String name;
  @HiveField(2)
  String email;
  @HiveField(3)
  String phone;
  @HiveField(4)
  String address;
  @HiveField(5)
  String photo;
  @HiveField(6)
  String password;
  Account({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.photo,
    required this.password,
  });

  Account copyWith({
    int? uid,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? photo,
    String? password,
  }) {
    return Account(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photo: photo ?? this.photo,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'photo': photo,
      'password': password,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      uid: map['uid']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      photo: map['photo'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Account(uid: $uid, name: $name, email: $email, phone: $phone, address: $address, photo: $photo, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Account &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.address == address &&
        other.photo == photo &&
        other.password == password;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        photo.hashCode ^
        password.hashCode;
  }
}
