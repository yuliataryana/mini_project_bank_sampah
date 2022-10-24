import 'dart:convert';

import 'package:hive/hive.dart';
part 'session.g.dart';

@HiveType(typeId: 1)
class Session {
  @HiveField(0)
  int uid;
  @HiveField(1)
  String email;
  Session({
    required this.uid,
    required this.email,
  });

  Session copyWith({
    int? uid,
    String? email,
  }) {
    return Session(
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      uid: map['uid']?.toInt() ?? 0,
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source));

  @override
  String toString() => 'Session(uid: $uid, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Session && other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;
}
