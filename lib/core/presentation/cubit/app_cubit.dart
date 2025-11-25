import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../features/auth/domain/usecases/get_refresh_token_use_case.dart';
import '../../errors/failure.dart';
import '../../usecase/use_case.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required GetRefreshTokenUseCase getRefreshTokenUseCase})
    : _getRefreshTokenUseCase = getRefreshTokenUseCase,
      super(AppInitial());

  final GetRefreshTokenUseCase _getRefreshTokenUseCase;

  Future<void> initializeApp() async {
    final refreshToken = await _getRefreshTokenUseCase();

    refreshToken.fold(
      (failure) => emit(AppFailure(failure: failure)),
      (token) => token != null ? emit(AppSuccess()) : emit(NavigateToLogin()),
    );
  }
}
