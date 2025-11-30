import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:qualitysphere/core/errors/failures.dart';
import 'package:qualitysphere/features/auth/domain/entities/user.dart';
import 'package:qualitysphere/features/auth/domain/repositories/auth_repository.dart';

/// Use case pour inscrire un nouvel utilisateur.
/// NOTE: le rôle par défaut est UserRole.user (admin est créé manuellement en DB).
class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<Either<Failure, User>> call(RegisterParams params) {
    return repository.register(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String? fullName;

  const RegisterParams({
    required this.email,
    required this.password,
    this.fullName,
  });

  @override
  List<Object?> get props => [email, password, fullName];
}
