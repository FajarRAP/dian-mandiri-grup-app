import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'core/common/constants.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/fetch_user_from_storage_use_case.dart';
import 'features/auth/domain/usecases/fetch_user_use_case.dart';
import 'features/auth/domain/usecases/refresh_token_use_case.dart';
import 'features/auth/domain/usecases/sign_in_use_case.dart';
import 'features/auth/domain/usecases/sign_out_use_case.dart';
import 'features/auth/domain/usecases/update_profile_use_case.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/tracker/data/datasources/shipment_remote_data_source.dart';
import 'features/tracker/data/repositories/shipment_repository_impl.dart';
import 'features/tracker/domain/repositories/shipment_repository.dart';
import 'features/tracker/domain/usecases/create_shipment_report_use_case.dart';
import 'features/tracker/domain/usecases/delete_shipment_use_case.dart';
import 'features/tracker/domain/usecases/download_shipment_report_use_case.dart';
import 'features/tracker/domain/usecases/fetch_shipment_by_id_use_case.dart';
import 'features/tracker/domain/usecases/fetch_shipment_by_receipt_number_use_case.dart';
import 'features/tracker/domain/usecases/fetch_shipment_reports_use_case.dart';
import 'features/tracker/domain/usecases/fetch_shipments_use_case.dart';
import 'features/tracker/domain/usecases/insert_shipment_document_use_case.dart';
import 'features/tracker/domain/usecases/insert_shipment_use_case.dart';
import 'features/tracker/presentation/cubit/shipment_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());

  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: dotenv.get('API_URL'),
        connectTimeout: const Duration(seconds: 5),
      ),
    )..interceptors.add(
        InterceptorsWrapper(
          onError: (error, handler) async {
            final storage = getIt.get<FlutterSecureStorage>();
            final refreshToken = await storage.read(key: refreshTokenKey);
            final authRepository = getIt.get<AuthRepository>();

            if (error.requestOptions.path == '$authEndpoint/refresh') {
              if (error.response?.statusCode == 401) {
                await storage.deleteAll();
              }
            } else {
              if (error.response?.statusCode == 401 && refreshToken != null) {
                await authRepository.refreshToken(
                    refreshToken: refreshToken);
              }
            }

            return handler.next(error);
          },
          onRequest: (options, handler) async {
            final storage = getIt.get<FlutterSecureStorage>();
            final accessToken = await storage.read(key: accessTokenKey);

            if (options.path != '$authEndpoint/refresh') {
              options.headers = {
                'Accept': 'application/json',
                'Authorization': 'Bearer $accessToken',
              };
            }

            return handler.next(options);
          },
          onResponse: (response, handler) async {
            final storage = getIt.get<FlutterSecureStorage>();
            if (response.requestOptions.path == '$authEndpoint/refresh' &&
                response.statusCode == 401) {
              await storage.deleteAll();
            }
            return handler.next(response);
          },
        ),
      ),
  );

  // Auth
  getIt
    ..registerLazySingleton<AuthRemoteDataSource<Response>>(
        () => AuthRemoteDataSourceImpl(dio: getIt.get()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        authRemoteDataSource: getIt.get(),
        googleSignIn: GoogleSignIn(),
        storage: getIt.get()))
    ..registerLazySingleton<AuthCubit>(() => AuthCubit(
        fetchUserUseCase: FetchUserUseCase(authRepository: getIt.get()),
        fetchUserFromStorageUseCase:
            FetchUserFromStorageUseCase(authRepository: getIt.get()),
        refreshTokenUseCase: RefreshTokenUseCase(authRepository: getIt.get()),
        signInUseCase: SignInUseCase(authRepository: getIt.get()),
        signOutUseCase: SignOutUseCase(authRepository: getIt.get()),
        updateProfileUseCase:
            UpdateProfileUseCase(authRepository: getIt.get())));

  // Ship
  getIt
    ..registerLazySingleton<ShipmentRemoteDataSource<Response>>(
        () => ShipmentRemoteDataSourceImpl(dio: getIt.get()))
    ..registerLazySingleton<ShipmentRepository>(
        () => ShipmentRepositoryImpl(shipmentRemoteDataSource: getIt.get()))
    ..registerLazySingleton<ShipmentCubit>(() => ShipmentCubit(
        createShipmentReportUseCase:
            CreateShipmentReportUseCase(shipmentRepository: getIt.get()),
        deleteShipmentUseCase:
            DeleteShipmentUseCase(shipmentRepository: getIt.get()),
        fetchShipmentByIdUseCase:
            FetchShipmentByIdUseCase(shipmentRepository: getIt.get()),
        fetchShipmentByReceiptNumberUseCase:
            FetchShipmentByReceiptNumberUseCase(
                shipmentRepository: getIt.get()),
        fetchShipmentReportsUseCase:
            FetchShipmentReportsUseCase(shipmentRepository: getIt.get()),
        fetchShipmentsUseCase:
            FetchShipmentsUseCase(shipmentRepository: getIt.get()),
        insertShipmentDocumentUseCase:
            InsertShipmentDocumentUseCase(shipmentRepository: getIt.get()),
        insertShipmentUseCase:
            InsertShipmentUseCase(shipmentRepository: getIt.get()),
        downloadShipmentReportUseCase:
            DownloadShipmentReportUseCase(shipmentRepository: getIt.get())));
}
