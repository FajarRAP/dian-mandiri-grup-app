import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'core/common/constants.dart';
import 'core/network/dio_interceptor.dart';
import 'core/services/google_sign_in_service.dart';
import 'core/services/image_picker_service.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
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
      () => const FlutterSecureStorage());

  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: const Duration(seconds: 5),
      ),
    )..interceptors.add(DioInterceptor()),
  );

  getIt
    ..registerLazySingleton<ImagePickerService>(() => ImagePickerServiceImpl())
    ..registerLazySingleton(
      () => GoogleSignInService(
          serverClientId: const String.fromEnvironment('SERVER_CLIENT_ID'),
          googleSignIn: GoogleSignIn.instance),
    );

  // Auth
  getIt
    ..registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(storage: getIt.get()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        dio: getIt.get(),
        googleSignIn: getIt.get(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authLocalDataSource: getIt.get(),
        authRemoteDataSource: getIt.get(),
      ),
    )
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
    ..registerLazySingleton<ShipmentRemoteDataSource>(
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

  // Supplier
  getIt
    ..registerLazySingleton<SupplierRemoteDataSource>(
        () => SupplierRemoteDataSourceImpl(dio: getIt.get()))
    ..registerLazySingleton<SupplierRepository>(
        () => SupplierRepositoryImpl(supplierRemoteDataSource: getIt.get()))
    ..registerLazySingleton<SupplierCubit>(() => SupplierCubit(
        fetchSupplierUseCase:
            FetchSupplierUseCase(supplierRepository: getIt.get()),
        fetchSuppliersUseCase:
            FetchSuppliersUseCase(supplierRepository: getIt.get()),
        fetchSuppliersDropdownUseCase:
            FetchSuppliersDropdownUseCase(supplierRepository: getIt.get()),
        insertSupplierUseCase:
            InsertSupplierUseCase(supplierRepository: getIt.get()),
        updateSupplierUseCase:
            UpdateSupplierUseCase(supplierRepository: getIt.get())));

  // Warehouse
  getIt
    ..registerLazySingleton<WarehouseRemoteDataSource>(
        () => WarehouseRemoteDataSourceImpl(dio: getIt()))
    ..registerLazySingleton<WarehouseRepository>(
        () => WarehouseRepositoryImpl(warehouseRemoteDataSource: getIt()))
    ..registerSingleton(DeletePurchaseNoteUseCase(warehouseRepository: getIt()))
    ..registerSingleton(FetchPurchaseNoteUseCase(warehouseRepository: getIt()))
    ..registerSingleton(FetchPurchaseNotesUseCase(warehouseRepository: getIt()))
    ..registerSingleton(
        FetchPurchaseNotesDropdownUseCase(warehouseRepository: getIt()))
    ..registerSingleton(
        InsertPurchaseNoteManualUseCase(warehouseRepository: getIt()))
    ..registerSingleton(
        InsertPurchaseNoteFileUseCase(warehouseRepository: getIt()))
    ..registerSingleton(InsertReturnCostUseCase(warehouseRepository: getIt()))
    ..registerSingleton(InsertShippingFeeUseCase(warehouseRepository: getIt()))
    ..registerSingleton(UpdatePurchaseNoteUseCase(warehouseRepository: getIt()))
    ..registerLazySingleton<WarehouseCubit>(() => WarehouseCubit(
        deletePurchaseNoteUseCase: getIt(),
        fetchPurchaseNoteUseCase: getIt(),
        fetchPurchaseNotesUseCase: getIt(),
        fetchPurchaseNotesDropdownUseCase: getIt(),
        insertPurchaseNoteManualUseCase: getIt(),
        insertPurchaseNoteFileUseCase: getIt(),
        insertReturnCostUseCase: getIt(),
        insertShippingFeeUseCase: getIt(),
        updatePurchaseNoteUseCase: getIt(),
        imagePickerService: getIt()));
}
