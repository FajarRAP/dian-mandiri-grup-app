import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/exceptions/cache_exception.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSources {
  Future<void> cacheTokens({required TokenModel token});
  Future<void> cacheUser({required UserModel user});
  Future<void> clearCache();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<UserModel?> getUser();
}

class AuthLocalDataSourcesImpl extends AuthLocalDataSources {
  AuthLocalDataSourcesImpl({required this.storage});

  final FlutterSecureStorage storage;

  @override
  Future<void> cacheTokens({required TokenModel token}) async {
    try {
      await storage.write(key: accessTokenKey, value: token.accessToken);
      await storage.write(key: refreshTokenKey, value: token.refreshToken);
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }

  @override
  Future<void> cacheUser({required UserModel user}) async {
    try {
      await storage.write(key: userKey, value: jsonEncode(user.toJson()));
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await storage.deleteAll();
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await storage.read(key: accessTokenKey);
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await storage.read(key: refreshTokenKey);
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final user = await storage.read(key: userKey);

      if (user == null) return null;

      return UserModel.fromJson(jsonDecode(user));
    } catch (e) {
      throw CacheException(message: '$e');
    }
  }
}
