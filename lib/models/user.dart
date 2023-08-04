class User {
  final String name;
  final String fingerprint;
  final bool isSync;

  User({
    required this.name,
    required this.fingerprint,
    required this.isSync,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "fingerprint": fingerprint,
      "issync": isSync,
    };
  }
}
