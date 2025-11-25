part of 'auth_cubit.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

class FetchUser extends AuthState {}

class RefreshToken extends AuthState {}

class UpdateProfile extends AuthState {}

class FetchUserLoading extends FetchUser {}

class SignIn extends AuthState {
  const SignIn();
}

class SignOut extends AuthState {}

class FetchUserLoaded extends FetchUser {
  FetchUserLoaded({required this.user});

  final UserEntity user;
}

class FetchUserError extends FetchUser {
  FetchUserError({required this.message});

  final String message;
}

class RefreshTokenLoading extends RefreshToken {}

class RefreshTokenLoaded extends RefreshToken {}

class RefreshTokenError extends RefreshToken {
  RefreshTokenError({required this.message});

  final String message;
}

class SignInLoading extends SignIn {
  const SignInLoading();
}

class SignInLoaded extends SignIn {
  const SignInLoaded({required this.message, required this.user});

  final String message;
  final UserEntity user;

  @override
  List<Object?> get props => [message, user];
}

class SignInError extends SignIn {
  const SignInError({required this.message});

  final String message;
}

class SignOutLoading extends SignOut {}

class SignOutLoaded extends SignOut {
  SignOutLoaded({required this.message});

  final String message;
}

class SignOutError extends SignOut {
  SignOutError({required this.message});

  final String message;
}

class UpdateProfileLoading extends UpdateProfile {}

class UpdateProfileLoaded extends UpdateProfile {
  UpdateProfileLoaded({required this.message});

  final String message;
}

class UpdateProfileError extends UpdateProfile {
  UpdateProfileError({required this.message});

  final String message;
}

class RefreshTokenExpired extends AuthState {}
