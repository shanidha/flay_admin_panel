part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final User? user;
  final bool loading;
  final String? error;
  final String? info;
  const AuthState({this.user, this.loading = false, this.error, this.info});

  const AuthState.unknown() : this();
  const AuthState.unauthenticated() : this(user: null);
  const AuthState.authenticated(User u) : this(user: u);

  AuthState copyWith({User? user, bool? loading, String? error, String? info}) =>
      AuthState(
        user: user ?? this.user,
        loading: loading ?? this.loading,
        error: error,
        info: info,
      );

  bool get isAuthed => user != null;

  @override
  List<Object?> get props => [user, loading, error, info];
}