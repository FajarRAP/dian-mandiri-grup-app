part of 'user_cubit.dart';

enum UserStatus { initial, inProgress, success, failure }

class UserState extends Equatable {
  const UserState({required this.status, this.user, this.failure});

  factory UserState.initial() {
    return const UserState(status: UserStatus.initial);
  }

  final UserStatus status;
  final UserEntity? user;
  final Failure? failure;

  UserState copyWith({UserStatus? status, UserEntity? user, Failure? failure}) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, user, failure];
}
