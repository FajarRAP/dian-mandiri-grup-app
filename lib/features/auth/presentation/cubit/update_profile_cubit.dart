import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit({required UpdateProfileUseCase updateProfileUseCase})
    : _updateProfileUseCase = updateProfileUseCase,
      super(UpdateProfileInitial());

  final UpdateProfileUseCase _updateProfileUseCase;

  Future<void> updateProfile({required String name}) async {
    emit(UpdateProfileLoading());

    final result = await _updateProfileUseCase(
      UpdateProfileUseCaseParams(name: name),
    );

    result.fold(
      (failure) => emit(UpdateProfileFailure(failure: failure)),
      (message) => emit(UpdateProfileSuccess(message: message)),
    );
  }
}
