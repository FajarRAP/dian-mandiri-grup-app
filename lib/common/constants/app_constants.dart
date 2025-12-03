class AppConstants {
  const AppConstants._();

  static const apiUrl = String.fromEnvironment('API_URL');
  static const accessTokenKey = String.fromEnvironment('ACCESS_TOKEN_KEY');
  static const refreshTokenKey = String.fromEnvironment('REFRESH_TOKEN_KEY');
  static const userKey = String.fromEnvironment('USER_KEY');

  static const scanStage = 'scan';
  static const pickUpStage = 'pick_up';
  static const checkStage = 'check';
  static const packStage = 'pack';
  static const sendStage = 'send';
  static const returnStage = 'return';
  static const cancelStage = 'cancel';

  static const pendingReport = 'pending';
  static const processingReport = 'processing';
  static const completedReport = 'completed';
  static const failedReport = 'failed';

  static const kSpaceBarHeight = 88.0;
}
