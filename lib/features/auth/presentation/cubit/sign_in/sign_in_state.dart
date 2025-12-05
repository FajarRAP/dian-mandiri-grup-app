part of 'sign_in_cubit.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

class SignInInProgress extends SignInState {
  const SignInInProgress();
}

class SignInSuccess extends SignInState {
  const SignInSuccess({required this.message, required this.user});

  final String message;
  final UserEntity user;

  @override
  List<Object> get props => [message, user];
}

class SignInFailure extends SignInState {
  const SignInFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
