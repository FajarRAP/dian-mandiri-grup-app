import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  const GoogleSignInService({
    required this.serverClientId,
    required GoogleSignIn googleSignIn,
  }) : _googleSignIn = googleSignIn;

  final String serverClientId;
  final GoogleSignIn _googleSignIn;

  Future<void> initialize() async {
    await _googleSignIn.initialize(serverClientId: serverClientId);
  }

  Future<String?> authenticate() async {
    final result = await _googleSignIn.authenticate();
    final headers = await result.authorizationClient.authorizationHeaders([
      'openid',
    ]);

    if (!(headers?.containsKey('Authorization') ?? false)) return null;

    return '${headers?['Authorization']}'.split('Bearer ').last;
  }

  Future<void> signOut() async {
    return await _googleSignIn.signOut();
  }
}
