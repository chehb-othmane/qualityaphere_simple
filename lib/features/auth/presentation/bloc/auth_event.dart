part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// يتحقق واش كاين user فـ cache (launch app)
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// login event
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// register event
class AuthRegisterRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}

/// logout event
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
