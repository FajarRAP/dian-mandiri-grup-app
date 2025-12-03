import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/usecase/use_case.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/sign_in_use_case.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required SignInUseCase signInUseCase})
    : _signInUseCase = signInUseCase,
      super(SignInInitial());

  final SignInUseCase _signInUseCase;

  Future<void> signIn() async {
    emit(const SignInInProgress());

    final result = await _signInUseCase();

    result.fold(
      (failure) => emit(SignInFailure(message: failure.message)),
      (signIn) =>
          emit(SignInSuccess(message: signIn.message, user: signIn.user)),
    );
  }
}
