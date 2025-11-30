import 'package:dartz/dartz.dart';
import 'package:qualitysphere/core/errors/failures.dart';
import 'package:qualitysphere/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Log in with email & password.
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register a new user (role will be User by default).
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    String? fullName,
  });

  /// Retourne l'utilisateur courant (s'il est déjà authentifié),
  /// sinon retourne Right(null) ou un Failure selon stratégie.
  Future<Either<Failure, User?>> getCurrentUser();

  /// Supprime la session (token, cache, etc.).
  Future<Either<Failure, void>> logout();
}
