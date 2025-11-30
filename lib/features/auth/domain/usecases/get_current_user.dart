import 'package:dartz/dartz.dart';

import 'package:qualitysphere/core/errors/failures.dart';
import 'package:qualitysphere/features/auth/domain/entities/user.dart';
import 'package:qualitysphere/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<Either<Failure, User?>> call() {
    return repository.getCurrentUser();
  }
}
