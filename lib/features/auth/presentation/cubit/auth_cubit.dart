import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/helpers.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/fetch_user_from_storage_use_case.dart';
import '../../domain/usecases/fetch_user_use_case.dart';
import '../../domain/usecases/refresh_token_use_case.dart';
import '../../domain/usecases/sign_in_use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required FetchUserUseCase fetchUserUseCase,
    required FetchUserFromStorageUseCase fetchUserFromStorageUseCase,
    required RefreshTokenUseCase refreshTokenUseCase,
    required SignInUseCase signInUseCase,
    required SignOutUseCase signOutUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required FlutterSecureStorage storage,
  })  : _fetchUserUseCase = fetchUserUseCase,
        _fetchUserFromStorageUseCase = fetchUserFromStorageUseCase,
        _refreshTokenUseCase = refreshTokenUseCase,
        _signInUseCase = signInUseCase,
        _signOutUseCase = signOutUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _storage = storage,
        super(AuthInitial());

  final FetchUserUseCase _fetchUserUseCase;
  final FetchUserFromStorageUseCase _fetchUserFromStorageUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final FlutterSecureStorage _storage;

  late UserEntity user;

  Future<void> fetchUser() async {
    emit(FetchUserLoading());

    final refreshToken = await _storage.read(key: refreshTokenKey);
    final result = await _fetchUserUseCase();

    result.fold(
      (l) => isRefreshed(l, refreshToken)
          ? fetchUser()
          : emit(FetchUserError(message: l.message)),
      (r) {
        user = r;
        emit(FetchUserLoaded());
      },
    );
  }

  Future<void> fetchUserFromStorage() async {
    emit(FetchUserLoading());

    final userFromStorage = await _fetchUserFromStorageUseCase();

    userFromStorage.fold(
      (l) => emit(FetchUserError(message: l.message)),
      (r) {
        user = r;
        emit(FetchUserLoaded());
      },
    );
  }

  Future<void> refreshToken() async {
    emit(RefreshTokenLoading());

    final refreshToken = await _storage.read(key: refreshTokenKey);
    final result = await _refreshTokenUseCase('$refreshToken');

    result.fold(
      (l) => emit(RefreshTokenError(message: l.message)),
      (r) => emit(RefreshTokenLoaded()),
    );
  }

  Future<void> signIn() async {
    emit(SignInLoading());

    final result = await _signInUseCase();

    result.fold(
      (l) => emit(SignInError(message: l.message)),
      (r) {
        user = r;
        emit(SignInLoaded(message: 'Berhasil sign in'));
      },
    );
  }

  Future<void> signOut() async {
    emit(SignOutLoading());

    final result = await _signOutUseCase();

    result.fold(
      (l) => emit(SignOutError(message: l.message)),
      (r) => emit(SignOutLoaded(message: 'Berhasil sign out')),
    );
  }

  Future<void> updateProfile({required String name}) async {
    emit(UpdateProfileLoading());

    final refreshToken = await _storage.read(key: refreshTokenKey);
    final result = await _updateProfileUseCase(name);

    result.fold(
      (l) => isRefreshed(l, refreshToken)
          ? updateProfile(name: name)
          : emit(UpdateProfileError(message: l.message)),
      (r) => emit(UpdateProfileLoaded(message: r)),
    );
  }
}
