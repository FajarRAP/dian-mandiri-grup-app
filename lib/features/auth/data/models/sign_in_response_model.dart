import 'package:equatable/equatable.dart';

import '../../../../core/utils/typedefs.dart';
import 'user_model.dart';

class SignInResponseModel extends Equatable {
  const SignInResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.message,
    required this.user,
  });

  factory SignInResponseModel.fromJson(JsonMap json) {
    final data = JsonMap.from(json['data']);

    return SignInResponseModel(
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
        message: json['message'],
        user: UserModel.fromJson(data['user']));
  }

  final String accessToken;
  final String refreshToken;
  final String message;
  final UserModel user;

  @override
  List<Object?> get props => [accessToken, refreshToken, message, user];
}
