import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../features/auth/domain/entities/user_entity.dart';
import '../../../features/auth/domain/usecases/fetch_user_from_storage_use_case.dart';
import '../../../features/auth/domain/usecases/get_refresh_token_use_case.dart';
import '../../errors/failure.dart';
import '../../usecase/use_case.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required GetRefreshTokenUseCase getRefreshTokenUseCase,
    required FetchUserFromStorageUseCase fetchUserFromStorageUseCase,
  }) : _getRefreshTokenUseCase = getRefreshTokenUseCase,
       _fetchUserFromStorageUseCase = fetchUserFromStorageUseCase,
       super(AppInitial());

  final GetRefreshTokenUseCase _getRefreshTokenUseCase;
  final FetchUserFromStorageUseCase _fetchUserFromStorageUseCase;

  Future<void> initializeApp() async {
    final refreshToken = await _getRefreshTokenUseCase();

    refreshToken.fold((failure) => emit(AppFailure(failure: failure)), (
      token,
    ) async {
      if (token == null) return emit(NavigateToLogin());

      final user = await _fetchUserFromStorageUseCase();

      emit(AppSuccess(user: user.getOrElse(() => null)));
    });
  }
}
