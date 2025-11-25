import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/fetch_user_from_storage_use_case.dart';
import '../../domain/usecases/fetch_user_use_case.dart';
import '../../domain/usecases/refresh_token_use_case.dart';
import '../../domain/usecases/sign_in_use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required FetchUserUseCase fetchUserUseCase,
    required FetchUserFromStorageUseCase fetchUserFromStorageUseCase,
    required RefreshTokenUseCase refreshTokenUseCase,
    required SignInUseCase signInUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _fetchUserUseCase = fetchUserUseCase,
       _fetchUserFromStorageUseCase = fetchUserFromStorageUseCase,
       _refreshTokenUseCase = refreshTokenUseCase,
       _signInUseCase = signInUseCase,
       _signOutUseCase = signOutUseCase,

       super(AuthInitial());

  final FetchUserUseCase _fetchUserUseCase;
  final FetchUserFromStorageUseCase _fetchUserFromStorageUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;

  Future<void> fetchUser() async {
    emit(FetchUserLoading());

    final result = await _fetchUserUseCase();

    result.fold(
      (failure) => emit(FetchUserError(message: failure.message)),
      (user) => emit(FetchUserLoaded(user: user)),
    );
  }

  Future<void> fetchUserFromStorage() async {
    emit(FetchUserLoading());

    final userFromStorage = await _fetchUserFromStorageUseCase();

    userFromStorage.fold(
      (failure) => emit(FetchUserError(message: failure.message)),
      (user) => user == null
          ? emit(FetchUserError(message: 'No user found in storage'))
          : emit(FetchUserLoaded(user: user)),
    );
  }

  Future<void> refreshToken({required String? refreshToken}) async {
    emit(RefreshTokenLoading());

    final params = RefreshTokenUseCaseParams(refreshToken: '$refreshToken');
    final result = await _refreshTokenUseCase(params);

    result.fold(
      (failure) => emit(RefreshTokenError(message: failure.message)),
      (message) => emit(RefreshTokenLoaded()),
    );
  }

  Future<void> signIn() async {
    emit(const SignInLoading());

    final result = await _signInUseCase();

    result.fold(
      (failure) => emit(SignInError(message: failure.message)),
      (signIn) =>
          emit(SignInLoaded(message: signIn.message, user: signIn.user)),
    );
  }

  Future<void> signOut() async {
    emit(SignOutLoading());

    final result = await _signOutUseCase();

    result.fold(
      (failure) => emit(SignOutError(message: failure.message)),
      (message) => emit(SignOutLoaded(message: message)),
    );
  }

  void refreshTokenExpired() => emit(RefreshTokenExpired());
}
