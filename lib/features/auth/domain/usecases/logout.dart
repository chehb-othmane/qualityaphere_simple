import 'package:dartz/dartz.dart';

import 'package:qualitysphere/core/errors/failures.dart';
import 'package:qualitysphere/features/auth/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
