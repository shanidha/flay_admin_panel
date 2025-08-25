import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/auth_state_stream.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final SignOut _signOut;
  final ForgotPassword _forgot;
  final AuthStateStream _authStream;

  AuthBloc(this._signIn, this._signOut, this._forgot, this._authStream)
      : super(const AuthState.unknown()) {
    on<AuthSubscriptionRequested>(_onSub);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignOutRequested>(_onSignOut);
    on<AuthForgotPasswordRequested>(_onForgot);
  }

  Future<void> _onSub(AuthSubscriptionRequested e, Emitter<AuthState> emit) async {
    await emit.forEach<User?>(
      _authStream(),
      onData: (user) => user == null
          ? const AuthState.unauthenticated()
          : AuthState.authenticated(user),
    );
  }

  Future<void> _onSignIn(AuthSignInRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      await _signIn(e.email, e.password);
    } catch (err) {
      emit(state.copyWith(loading: false, error: err.toString()));
      return;
    }
    emit(state.copyWith(loading: false));
  }

  Future<void> _onSignOut(AuthSignOutRequested e, Emitter<AuthState> emit) async {
    await _signOut();
  }

  Future<void> _onForgot(AuthForgotPasswordRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      await _forgot(e.email);
      emit(state.copyWith(loading: false, info: 'Reset email sent'));
    } catch (err) {
      emit(state.copyWith(loading: false, error: err.toString()));
    }
  }
}