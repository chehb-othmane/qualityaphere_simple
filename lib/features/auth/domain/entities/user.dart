import 'package:equatable/equatable.dart';

/// Les rôles possibles dans QualitySphere.
/// - user  : utilisateur normal (créé via Sign Up)
/// - admin : créé manuellement dans la base de données
enum UserRole { user, admin }

class User extends Equatable {
  final String id;
  final String email;
  final String? fullName;
  final UserRole role;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    this.fullName,
    this.role = UserRole.user, // par défaut User
    this.createdAt,
  });

  bool get isAdmin => role == UserRole.admin;

  @override
  List<Object?> get props => [id, email, fullName, role, createdAt];
}
