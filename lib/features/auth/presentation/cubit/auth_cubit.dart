import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/exceptions/refresh_token.dart' as rt;
import '../../../../service_container.dart';
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
  })  : _fetchUserUseCase = fetchUserUseCase,
        _fetchUserFromStorageUseCase = fetchUserFromStorageUseCase,
        _refreshTokenUseCase = refreshTokenUseCase,
        _signInUseCase = signInUseCase,
        _signOutUseCase = signOutUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        super(AuthInitial());

  final FetchUserUseCase _fetchUserUseCase;
  final FetchUserFromStorageUseCase _fetchUserFromStorageUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  late UserEntity user;

  Future<void> fetchUser() async {
    emit(FetchUserLoading());
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _fetchUserUseCase();

    result.fold(
      (l) {
        if (l is rt.RefreshToken && refreshToken != null) {
          fetchUser();
        } else {
          emit(FetchUserError(message: l.message));
        }
      },
      (r) {
        user = r;
        emit(FetchUserLoaded());
      },
    );
  }

  Future<void> fetchUserFromStorage() async {
    final userFromStorage = await _fetchUserFromStorageUseCase();
    userFromStorage.fold(
      (l) {},
      (r) => user = r,
    );
  }

  Future<void> refreshToken() async {
    emit(RefreshTokenLoading());
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
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
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _updateProfileUseCase(name);

    result.fold(
      (l) {
        if (l is rt.RefreshToken && refreshToken != null) {
          updateProfile(name: name);
        } else {
          emit(UpdateProfileError(message: l.message));
        }
      },
      (r) => emit(UpdateProfileLoaded(message: r)),
    );
  }
}
