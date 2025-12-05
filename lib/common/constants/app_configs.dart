class AppConfigs {
  const AppConfigs._();

  static const apiUrl = String.fromEnvironment('API_URL');
  static const accessTokenKey = String.fromEnvironment('ACCESS_TOKEN_KEY');
  static const refreshTokenKey = String.fromEnvironment('REFRESH_TOKEN_KEY');
  static const userKey = String.fromEnvironment('USER_KEY');

  static const connectionTimeout = int.fromEnvironment('CONNECTION_TIMEOUT');
  static const receiveTimeout = int.fromEnvironment('RECEIVE_TIMEOUT');
}
