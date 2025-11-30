import 'package:qualitysphere/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.fullName,
    super.role = UserRole.user,
    super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roleString = (json['role'] as String?)?.toUpperCase() ?? 'USER';

    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      role: roleString == 'ADMIN' ? UserRole.admin : UserRole.user,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role == UserRole.admin ? 'ADMIN' : 'USER',
      'created_at': createdAt?.toIso8601String(),
    };
  }

  User toEntity() => User(
    id: id,
    email: email,
    fullName: fullName,
    role: role,
    createdAt: createdAt,
  );
}
