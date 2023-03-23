import 'dart:convert';

import 'package:hive/hive.dart';
part 'local_session.g.dart';

@HiveType(typeId: 1)
class LocalSession {
  @HiveField(0)
  int uid;
  @HiveField(1)
  String email;
  LocalSession({
    required this.uid,
    required this.email,
  });

  LocalSession copyWith({
    int? uid,
    String? email,
  }) {
    return LocalSession(
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

  factory LocalSession.fromMap(Map<String, dynamic> map) {
    return LocalSession(
      uid: map['uid']?.toInt() ?? 0,
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalSession.fromJson(String source) =>
      LocalSession.fromMap(json.decode(source));

  @override
  String toString() => 'LocalSession(uid: $uid, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocalSession && other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;
}
