import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ship_tracker/core/services/google_sign_in_service.dart';
import 'package:ship_tracker/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ship_tracker/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ship_tracker/features/tracker/data/datasources/shipment_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

class MockStorage extends Mock implements FlutterSecureStorage {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInService extends Mock implements GoogleSignInService {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockShipmentRemoteDataSource extends Mock
    implements ShipmentRemoteDataSource {}
