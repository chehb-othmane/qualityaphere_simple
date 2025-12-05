class User {
  final String id; // simple string id
  final String name;
  final String email;
  final String password; // just for demo (normalement hash)

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });
}
