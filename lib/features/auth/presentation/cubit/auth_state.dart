part of 'auth_cubit.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Unauthenticated extends AuthState {
  const Unauthenticated({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends AuthState {
  const AuthFailure({required this.failure});

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
