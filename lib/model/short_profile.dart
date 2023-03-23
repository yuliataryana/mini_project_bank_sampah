class ShortProfile {
  final String? id;
  final String? name;

  ShortProfile({
    this.id,
    this.name,
  });

  factory ShortProfile.fromJson(Map<String, dynamic> json) {
    return ShortProfile(
      id: json['userid'],
      name: json['username'],
    );
  }
}
