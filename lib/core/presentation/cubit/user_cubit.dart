import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../features/auth/domain/entities/user_entity.dart';
import '../../../features/auth/domain/usecases/fetch_user_from_storage_use_case.dart';
import '../../../features/auth/domain/usecases/fetch_user_use_case.dart';
import '../../errors/failure.dart';
import '../../usecase/use_case.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({
    required FetchUserUseCase fetchUserUseCase,
    required FetchUserFromStorageUseCase fetchUserFromStorageUseCase,
  }) : _fetchUserUseCase = fetchUserUseCase,
       _fetchUserFromStorageUseCase = fetchUserFromStorageUseCase,
       super(UserState.initial());

  final FetchUserUseCase _fetchUserUseCase;
  final FetchUserFromStorageUseCase _fetchUserFromStorageUseCase;

  UserEntity get user => state.user!;

  bool can(String permissionName) => user.can(permissionName);
  bool canAny(List<String> permissions) => user.canAny(permissions);
  bool canAll(List<String> permissions) => user.canAll(permissions);

  set setUser(UserEntity? user) =>
      emit(state.copyWith(user: user, status: UserStatus.success));

  void clearUser() => emit(UserState.initial());

  Future<void> fetchUser() async {
    emit(state.copyWith(status: UserStatus.inProgress));

    final result = await _fetchUserUseCase();

    result.fold(
      (_) => emit(state.copyWith(status: UserStatus.failure)),
      (user) => emit(state.copyWith(user: user, status: UserStatus.success)),
    );
  }

  Future<void> fetchUserFromStorage() async {
    emit(state.copyWith(status: UserStatus.inProgress));

    final result = await _fetchUserFromStorageUseCase();

    result.fold(
      (_) => emit(state.copyWith(status: UserStatus.failure)),
      (user) => emit(state.copyWith(user: user, status: UserStatus.success)),
    );
  }
}
