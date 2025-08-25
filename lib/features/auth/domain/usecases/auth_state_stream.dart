import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class AuthStateStream {
  final AuthRepository repo;
  AuthStateStream(this.repo);
  Stream<User?> call() => repo.authStateChanges();
}