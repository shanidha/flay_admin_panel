part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable { const AuthEvent(); @override List<Object?> get props => []; }
class AuthSubscriptionRequested extends AuthEvent {}
class AuthSignInRequested extends AuthEvent { final String email, password; const AuthSignInRequested(this.email, this.password); }
class AuthSignOutRequested extends AuthEvent {}
class AuthForgotPasswordRequested extends AuthEvent { final String email; const AuthForgotPasswordRequested(this.email); }