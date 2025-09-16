import 'token_model.dart';
import 'user_model.dart';

class SignInResponseModel {
  const SignInResponseModel({
    required this.token,
    required this.user,
  });

  final TokenModel token;
  final UserModel user;

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) =>
      SignInResponseModel(
          token: TokenModel(
              accessToken: json['data']['access_token'],
              refreshToken: json['data']['refresh_token'],
              message: json['message']),
          user: UserModel.fromJson(json['data']['user']));
}
