import 'package:equatable/equatable.dart';

import '../../../../core/utils/typedefs.dart';

class TokenModel extends Equatable {
  const TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.message,
  });

  factory TokenModel.fromJson(JsonMap json) {
    return TokenModel(
      accessToken: json['data']['access_token'],
      refreshToken: json['data']['refresh_token'],
      message: json['message'],
    );
  }

  final String accessToken;
  final String refreshToken;
  final String message;

  @override
  List<Object?> get props => [accessToken, refreshToken, message];
}
