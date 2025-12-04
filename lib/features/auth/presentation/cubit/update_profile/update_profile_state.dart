part of 'update_profile_cubit.dart';

sealed class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object> get props => [];
}

final class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {
  const UpdateProfileSuccess({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class UpdateProfileFailure extends UpdateProfileState {
  const UpdateProfileFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
