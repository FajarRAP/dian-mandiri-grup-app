import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/network/auth_status_stream.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required SignOutUseCase signOutUseCase,
    required AuthStatusStream authStatusStream,
  }) : _signOutUseCase = signOutUseCase,
       _authStatusStream = authStatusStream,
       super(AuthInitial()) {
    _listenAuthStatus();
  }

  final SignOutUseCase _signOutUseCase;
  final AuthStatusStream _authStatusStream;
  late StreamSubscription<bool> _authStatusSubscription;

  Future<void> signOut() async {
    emit(const AuthLoading());

    final result = await _signOutUseCase();

    result.fold(
      (failure) => emit(AuthFailure(failure: failure)),
      (message) => emit(Unauthenticated(message: message)),
    );
  }

  void _listenAuthStatus() {
    _authStatusSubscription = _authStatusStream.stream.listen((
      isAuthenticated,
    ) {
      if (!isAuthenticated) {
        signOut();
      }
    });
  }

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }
}
