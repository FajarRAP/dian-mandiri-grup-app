import 'package:equatable/equatable.dart';

import 'user_entity.dart';

class SignInEntity extends Equatable {
  const SignInEntity({required this.message, required this.user});

  final String message;
  final UserEntity user;

  @override
  List<Object?> get props => [message, user];
}
