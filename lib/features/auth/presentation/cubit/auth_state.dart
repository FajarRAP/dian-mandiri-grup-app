part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class FetchUser extends AuthState {}

class RefreshToken extends AuthState {}

class UpdateProfile extends AuthState {}

class FetchUserLoading extends FetchUser {}

class FetchUserLoaded extends FetchUser {}

class FetchUserError extends FetchUser {
  final String message;

  FetchUserError({required this.message});
}

class RefreshTokenLoading extends RefreshToken {}

class RefreshTokenLoaded extends RefreshToken {}

class RefreshTokenError extends RefreshToken {
  final String message;

  RefreshTokenError({required this.message});
}

class SignIn extends AuthState {}

class SignOut extends AuthState {}

class SignInLoading extends SignIn {}

class SignInLoaded extends SignIn {
  final String message;

  SignInLoaded({required this.message});
}

class SignInError extends SignIn {
  final String message;

  SignInError({required this.message});
}

class SignOutLoading extends SignOut {}

class SignOutLoaded extends SignOut {
  final String message;

  SignOutLoaded({required this.message});
}

class SignOutError extends SignOut {
  final String message;

  SignOutError({required this.message});
}

class UpdateProfileLoading extends UpdateProfile {}

class UpdateProfileLoaded extends UpdateProfile {
  final String message;

  UpdateProfileLoaded({required this.message});
}

class UpdateProfileError extends UpdateProfile {
  final String message;

  UpdateProfileError({required this.message});
}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {}

class AuthSignedOut extends AuthState {
  final String message;

  AuthSignedOut(this.message);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class UpdatingUser extends AuthState {}

class UserUpdated extends AuthState {}

class UpdateUserError extends AuthState {
  final String message;

  UpdateUserError(this.message);
}

class TokenSended extends AuthState {
  final String message;

  TokenSended(this.message);
}

class PasswordChanged extends AuthState {
  final String message;

  PasswordChanged(this.message);
}
