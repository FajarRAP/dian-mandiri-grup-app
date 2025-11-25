import 'package:bloc/bloc.dart';

import '../../../features/auth/domain/entities/user_entity.dart';
import '../../../features/auth/domain/usecases/fetch_user_from_storage_use_case.dart';
import '../../../features/auth/domain/usecases/fetch_user_use_case.dart';
import '../../usecase/use_case.dart';

class UserCubit extends Cubit<UserEntity?> {
  UserCubit({
    required FetchUserUseCase fetchUserUseCase,
    required FetchUserFromStorageUseCase fetchUserFromStorageUseCase,
  }) : _fetchUserUseCase = fetchUserUseCase,
       _fetchUserFromStorageUseCase = fetchUserFromStorageUseCase,
       super(null);

  final FetchUserUseCase _fetchUserUseCase;
  final FetchUserFromStorageUseCase _fetchUserFromStorageUseCase;

  bool can(String permissionName) => state?.can(permissionName) ?? false;
  bool canAny(List<String> permissions) => state?.canAny(permissions) ?? false;
  bool canAll(List<String> permissions) => state?.canAll(permissions) ?? false;

  set setUser(UserEntity? user) => emit(user);

  void clearUser() => emit(null);

  Future<void> fetchUser() async {
    final result = await _fetchUserUseCase();
    result.fold((_) => emit(null), (user) => emit(user));
  }

  Future<void> fetchUserFromStorage() async {
    final result = await _fetchUserFromStorageUseCase();
    result.fold((_) => emit(null), (user) => emit(user));
  }
}
