import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:qualitysphere/core/errors/failures.dart';
import 'package:qualitysphere/features/auth/domain/entities/user.dart';
import 'package:qualitysphere/features/auth/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(email: params.email, password: params.password);
  }
}

/// Les paramètres du use case Login (value object)
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
