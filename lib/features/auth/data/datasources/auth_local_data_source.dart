import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/utils/local_data_source_handler_mixin.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheTokens({required TokenModel token});
  Future<void> cacheUser({required UserModel user});
  Future<void> clearCache();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<UserModel?> getUser();
}

class AuthLocalDataSourceImpl
    with LocalDataSourceHandlerMixin
    implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl({required this.storage});

  final FlutterSecureStorage storage;

  @override
  Future<void> cacheTokens({required TokenModel token}) async {
    return await handleLocalDataSourceRequest<void>(() async {
      await storage.write(key: accessTokenKey, value: token.accessToken);
      await storage.write(key: refreshTokenKey, value: token.refreshToken);
    });
  }

  @override
  Future<void> cacheUser({required UserModel user}) async {
    return await handleLocalDataSourceRequest<void>(() async {
      await storage.write(key: userKey, value: jsonEncode(user.toJson()));
    });
  }

  @override
  Future<void> clearCache() async {
    return await handleLocalDataSourceRequest<void>(() async {
      await storage.deleteAll();
    });
  }

  @override
  Future<String?> getAccessToken() async {
    return await handleLocalDataSourceRequest<String?>(() async {
      return await storage.read(key: accessTokenKey);
    });
  }

  @override
  Future<String?> getRefreshToken() async {
    return await handleLocalDataSourceRequest<String?>(() async {
      return await storage.read(key: refreshTokenKey);
    });
  }

  @override
  Future<UserModel?> getUser() async {
    return await handleLocalDataSourceRequest<UserModel?>(() async {
      final user = await storage.read(key: userKey);

      if (user == null) return null;

      return UserModel.fromJson(jsonDecode(user));
    });
  }
}
