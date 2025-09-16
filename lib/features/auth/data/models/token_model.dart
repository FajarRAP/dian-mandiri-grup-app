class TokenModel {
  const TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.message,
  });

  final String accessToken;
  final String refreshToken;
  final String message;

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        accessToken: json['data']['access_token'],
        refreshToken: json['data']['refresh_token'],
        message: json['message'],
      );
}
