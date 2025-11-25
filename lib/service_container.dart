import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'core/common/constants.dart';
import 'core/network/dio_interceptor.dart';
import 'core/presentation/cubit/app_cubit.dart';
import 'core/presentation/cubit/user_cubit.dart';
import 'core/services/google_sign_in_service.dart';
import 'core/services/image_picker_service.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/fetch_user_from_storage_use_case.dart';
import 'features/auth/domain/usecases/fetch_user_use_case.dart';
import 'features/auth/domain/usecases/get_refresh_token_use_case.dart';
import 'features/auth/domain/usecases/refresh_token_use_case.dart';
import 'features/auth/domain/usecases/sign_in_use_case.dart';
import 'features/auth/domain/usecases/sign_out_use_case.dart';
import 'features/auth/domain/usecases/update_profile_use_case.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/update_profile_cubit.dart';
import 'features/supplier/data/datasources/supplier_remote_data_source.dart';
import 'features/supplier/data/repositories/supplier_repository_impl.dart';
import 'features/supplier/domain/repositories/supplier_repository.dart';
import 'features/supplier/domain/usecases/fetch_supplier_use_case.dart';
import 'features/supplier/domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import 'features/supplier/domain/usecases/fetch_suppliers_use_case.dart';
import 'features/supplier/domain/usecases/insert_supplier_use_case.dart';
import 'features/supplier/domain/usecases/update_supplier_use_case.dart';
import 'features/supplier/presentation/cubit/supplier_cubit.dart';
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
import 'features/warehouse/data/datasources/warehouse_remote_data_source.dart';
import 'features/warehouse/data/repositories/warehouse_repository_impl.dart';
import 'features/warehouse/domain/repositories/warehouse_repository.dart';
import 'features/warehouse/domain/usecases/delete_purchase_note_use_case.dart';
import 'features/warehouse/domain/usecases/fetch_purchase_note_use_case.dart';
import 'features/warehouse/domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import 'features/warehouse/domain/usecases/fetch_purchase_notes_use_case.dart';
import 'features/warehouse/domain/usecases/insert_purchase_note_file_use_case.dart';
import 'features/warehouse/domain/usecases/insert_purchase_note_manual_use_case.dart';
import 'features/warehouse/domain/usecases/insert_return_cost_use_case.dart';
import 'features/warehouse/domain/usecases/insert_shipping_fee_use_case.dart';
import 'features/warehouse/domain/usecases/update_purchase_note_use_case.dart';
import 'features/warehouse/presentation/cubit/warehouse_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Services
  getIt
    ..registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: apiUrl,
          connectTimeout: const Duration(seconds: 5),
        ),
      )..interceptors.add(DioInterceptor()),
    )
    ..registerLazySingleton<ImagePickerService>(() => ImagePickerServiceImpl())
    ..registerLazySingleton(
      () => GoogleSignInService(
        serverClientId: const String.fromEnvironment('SERVER_CLIENT_ID'),
        googleSignIn: GoogleSignIn.instance,
      ),
    );

  // Auth
  getIt
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(storage: getIt()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dio: getIt(), googleSignIn: getIt()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authLocalDataSource: getIt(),
        authRemoteDataSource: getIt(),
      ),
    )
    ..registerSingleton(GetRefreshTokenUseCase(authRepository: getIt()))
    ..registerSingleton(FetchUserUseCase(authRepository: getIt()))
    ..registerSingleton(FetchUserFromStorageUseCase(authRepository: getIt()))
    ..registerSingleton(RefreshTokenUseCase(authRepository: getIt()))
    ..registerSingleton(SignInUseCase(authRepository: getIt()))
    ..registerSingleton(SignOutUseCase(authRepository: getIt()))
    ..registerSingleton(UpdateProfileUseCase(authRepository: getIt()))
    ..registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        fetchUserUseCase: getIt(),
        fetchUserFromStorageUseCase: getIt(),
        refreshTokenUseCase: getIt(),
        signInUseCase: getIt(),
        signOutUseCase: getIt(),
      ),
    );

  // Ship
  getIt
    ..registerLazySingleton<ShipmentRemoteDataSource>(
      () => ShipmentRemoteDataSourceImpl(dio: getIt()),
    )
    ..registerLazySingleton<ShipmentRepository>(
      () => ShipmentRepositoryImpl(shipmentRemoteDataSource: getIt()),
    )
    ..registerSingleton(
      CreateShipmentReportUseCase(shipmentRepository: getIt()),
    )
    ..registerSingleton(DeleteShipmentUseCase(shipmentRepository: getIt()))
    ..registerSingleton(FetchShipmentByIdUseCase(shipmentRepository: getIt()))
    ..registerSingleton(
      FetchShipmentByReceiptNumberUseCase(shipmentRepository: getIt()),
    )
    ..registerSingleton(
      FetchShipmentReportsUseCase(shipmentRepository: getIt()),
    )
    ..registerSingleton(FetchShipmentsUseCase(shipmentRepository: getIt()))
    ..registerSingleton(
      InsertShipmentDocumentUseCase(shipmentRepository: getIt()),
    )
    ..registerSingleton(InsertShipmentUseCase(shipmentRepository: getIt()))
    ..registerSingleton(
      DownloadShipmentReportUseCase(shipmentRepository: getIt()),
    )
    ..registerLazySingleton<ShipmentCubit>(
      () => ShipmentCubit(
        createShipmentReportUseCase: getIt(),
        deleteShipmentUseCase: getIt(),
        fetchShipmentByIdUseCase: getIt(),
        fetchShipmentByReceiptNumberUseCase: getIt(),
        fetchShipmentReportsUseCase: getIt(),
        fetchShipmentsUseCase: getIt(),
        insertShipmentDocumentUseCase: getIt(),
        insertShipmentUseCase: getIt(),
        downloadShipmentReportUseCase: getIt(),
      ),
    );

  // Supplier
  getIt
    ..registerLazySingleton<SupplierRemoteDataSource>(
      () => SupplierRemoteDataSourceImpl(dio: getIt()),
    )
    ..registerLazySingleton<SupplierRepository>(
      () => SupplierRepositoryImpl(supplierRemoteDataSource: getIt()),
    )
    ..registerSingleton(FetchSupplierUseCase(supplierRepository: getIt()))
    ..registerSingleton(FetchSuppliersUseCase(supplierRepository: getIt()))
    ..registerSingleton(
      FetchSuppliersDropdownUseCase(supplierRepository: getIt()),
    )
    ..registerSingleton(InsertSupplierUseCase(supplierRepository: getIt()))
    ..registerSingleton(UpdateSupplierUseCase(supplierRepository: getIt()))
    ..registerLazySingleton<SupplierCubit>(
      () => SupplierCubit(
        fetchSupplierUseCase: getIt(),
        fetchSuppliersUseCase: getIt(),
        fetchSuppliersDropdownUseCase: getIt(),
        insertSupplierUseCase: getIt(),
        updateSupplierUseCase: getIt(),
      ),
    );

  // Warehouse
  getIt
    ..registerLazySingleton<WarehouseRemoteDataSource>(
      () => WarehouseRemoteDataSourceImpl(dio: getIt()),
    )
    ..registerLazySingleton<WarehouseRepository>(
      () => WarehouseRepositoryImpl(warehouseRemoteDataSource: getIt()),
    )
    ..registerSingleton(DeletePurchaseNoteUseCase(warehouseRepository: getIt()))
    ..registerSingleton(FetchPurchaseNoteUseCase(warehouseRepository: getIt()))
    ..registerSingleton(FetchPurchaseNotesUseCase(warehouseRepository: getIt()))
    ..registerSingleton(
      FetchPurchaseNotesDropdownUseCase(warehouseRepository: getIt()),
    )
    ..registerSingleton(
      InsertPurchaseNoteManualUseCase(warehouseRepository: getIt()),
    )
    ..registerSingleton(
      InsertPurchaseNoteFileUseCase(warehouseRepository: getIt()),
    )
    ..registerSingleton(InsertReturnCostUseCase(warehouseRepository: getIt()))
    ..registerSingleton(InsertShippingFeeUseCase(warehouseRepository: getIt()))
    ..registerSingleton(UpdatePurchaseNoteUseCase(warehouseRepository: getIt()))
    ..registerLazySingleton<WarehouseCubit>(
      () => WarehouseCubit(
        deletePurchaseNoteUseCase: getIt(),
        fetchPurchaseNoteUseCase: getIt(),
        fetchPurchaseNotesUseCase: getIt(),
        fetchPurchaseNotesDropdownUseCase: getIt(),
        insertPurchaseNoteManualUseCase: getIt(),
        insertPurchaseNoteFileUseCase: getIt(),
        insertReturnCostUseCase: getIt(),
        insertShippingFeeUseCase: getIt(),
        updatePurchaseNoteUseCase: getIt(),
        imagePickerService: getIt(),
      ),
    );

  getIt
    ..registerLazySingleton(() => AppCubit(getRefreshTokenUseCase: getIt()))
    ..registerLazySingleton(
      () => UserCubit(
        fetchUserUseCase: getIt(),
        fetchUserFromStorageUseCase: getIt(),
      ),
    )
    ..registerFactory(() => UpdateProfileCubit(updateProfileUseCase: getIt()));
}
