import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share_plus/share_plus.dart';

import 'core/common/constants.dart';
import 'core/network/dio_interceptor.dart';
import 'core/presentation/cubit/app_cubit.dart';
import 'core/presentation/cubit/dropdown_cubit.dart';
import 'core/presentation/cubit/user_cubit.dart';
import 'core/services/file_interaction_service.dart';
import 'core/services/file_service.dart';
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
import 'features/supplier/domain/usecases/create_supplier_use_case.dart';
import 'features/supplier/domain/usecases/fetch_supplier_use_case.dart';
import 'features/supplier/domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import 'features/supplier/domain/usecases/fetch_suppliers_use_case.dart';
import 'features/supplier/domain/usecases/update_supplier_use_case.dart';
import 'features/supplier/presentation/cubit/create_supplier/create_supplier_cubit.dart';
import 'features/supplier/presentation/cubit/supplier/supplier_cubit.dart';
import 'features/supplier/presentation/cubit/supplier_detail/supplier_detail_cubit.dart';
import 'features/supplier/presentation/cubit/update_supplier/update_supplier_cubit.dart';
import 'features/tracker/data/datasources/shipment_remote_data_source.dart';
import 'features/tracker/data/repositories/shipment_repository_impl.dart';
import 'features/tracker/domain/repositories/shipment_repository.dart';
import 'features/tracker/domain/usecases/check_shipment_report_existence_use_case.dart';
import 'features/tracker/domain/usecases/create_shipment_report_use_case.dart';
import 'features/tracker/domain/usecases/create_shipment_use_case.dart';
import 'features/tracker/domain/usecases/delete_shipment_use_case.dart';
import 'features/tracker/domain/usecases/download_shipment_report_use_case.dart';
import 'features/tracker/domain/usecases/fetch_shipment_reports_use_case.dart';
import 'features/tracker/domain/usecases/fetch_shipment_status_use_case.dart';
import 'features/tracker/domain/usecases/fetch_shipment_use_case.dart';
import 'features/tracker/domain/usecases/fetch_shipments_use_case.dart';
import 'features/tracker/domain/usecases/update_shipment_document_use_case.dart';
import 'features/tracker/presentation/cubit/shipment_detail/shipment_detail_cubit.dart';
import 'features/tracker/presentation/cubit/shipment_list/shipment_list_cubit.dart';
import 'features/tracker/presentation/cubit/shipment_report/shipment_report_cubit.dart';
import 'features/warehouse/data/datasources/warehouse_remote_data_source.dart';
import 'features/warehouse/data/repositories/warehouse_repository_impl.dart';
import 'features/warehouse/domain/repositories/warehouse_repository.dart';
import 'features/warehouse/domain/usecases/create_purchase_note_use_case.dart';
import 'features/warehouse/domain/usecases/delete_purchase_note_use_case.dart';
import 'features/warehouse/domain/usecases/fetch_purchase_note_use_case.dart';
import 'features/warehouse/domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import 'features/warehouse/domain/usecases/fetch_purchase_notes_use_case.dart';
import 'features/warehouse/domain/usecases/import_purchase_note_use_case.dart';
import 'features/warehouse/domain/usecases/add_shipping_fee_use_case.dart';
import 'features/warehouse/domain/usecases/update_purchase_note_use_case.dart';
import 'features/warehouse/domain/usecases/update_return_cost_use_case.dart';
import 'features/warehouse/presentation/cubit/import_purchase_note/import_purchase_note_cubit.dart';
import 'features/warehouse/presentation/cubit/purchase_note_cost/purchase_note_cost_cubit.dart';
import 'features/warehouse/presentation/cubit/purchase_note_detail/purchase_note_detail_cubit.dart';
import 'features/warehouse/presentation/cubit/purchase_note_form/purchase_note_form_cubit.dart';
import 'features/warehouse/presentation/cubit/purchase_note_list/purchase_note_list_cubit.dart';

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
    ..registerLazySingleton<FileInteractionService>(
      () => FileInteractionServiceImpl(sharePlus: SharePlus.instance),
    )
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
      () => ShipmentRemoteDataSourceImpl(
        dio: getIt(),
        fileService: const FileService(),
      ),
    )
    ..registerLazySingleton<ShipmentRepository>(
      () => ShipmentRepositoryImpl(
        shipmentRemoteDataSource: getIt(),
        fileService: const FileService(),
      ),
    )
    ..registerSingleton(
      CreateShipmentReportUseCase(shipmentRepository: getIt()),
    )
    ..registerSingleton(DeleteShipmentUseCase(shipmentRepository: getIt()))
    ..registerSingleton(FetchShipmentUseCase(shipmentRepository: getIt()))
    ..registerSingleton(FetchShipmentStatusUseCase(shipmentRepository: getIt()))
    ..registerSingleton(
      FetchShipmentReportsUseCase(shipmentRepository: getIt()),
    )
    ..registerSingleton(FetchShipmentsUseCase(shipmentRepository: getIt()))
    ..registerSingleton(
      UpdateShipmentDocumentUseCase(shipmentRepository: getIt()),
    )
    ..registerSingleton(CreateShipmentUseCase(shipmentRepository: getIt()))
    ..registerSingleton(
      CheckShipmentReportExistenceUseCase(shipmentRepository: getIt()),
    )
    ..registerSingleton(
      DownloadShipmentReportUseCase(shipmentRepository: getIt()),
    )
    ..registerFactory(
      () => ShipmentListCubit(
        fetchShipmentsUseCase: getIt(),
        insertShipmentUseCase: getIt(),
        deleteShipmentUseCase: getIt(),
      ),
    )
    ..registerFactory(
      () => ShipmentDetailCubit(
        fetchShipmentUseCase: getIt(),
        fetchShipmentStatusUseCase: getIt(),
        updateShipmentDocumentUseCase: getIt(),
      ),
    )
    ..registerFactory(
      () => ShipmentReportCubit(
        createShipmentReportUseCase: getIt(),
        downloadShipmentReportUseCase: getIt(),
        checkShipmentReportExistenceUseCase: getIt(),
        fetchShipmentReportsUseCase: getIt(),
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
    ..registerSingleton(CreateSupplierUseCase(supplierRepository: getIt()))
    ..registerSingleton(UpdateSupplierUseCase(supplierRepository: getIt()))
    ..registerFactory(() => SupplierCubit(fetchSuppliersUseCase: getIt()))
    ..registerFactory(() => SupplierDetailCubit(fetchSupplierUseCase: getIt()))
    ..registerFactory(() => UpdateSupplierCubit(updateSupplierUseCase: getIt()))
    ..registerFactory(
      () => CreateSupplierCubit(createSupplierUseCase: getIt()),
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
    ..registerSingleton(CreatePurchaseNoteUseCase(warehouseRepository: getIt()))
    ..registerSingleton(ImportPurchaseNoteUseCase(warehouseRepository: getIt()))
    ..registerSingleton(UpdateReturnCostUseCase(warehouseRepository: getIt()))
    ..registerSingleton(AddShippingFeeUseCase(warehouseRepository: getIt()))
    ..registerSingleton(UpdatePurchaseNoteUseCase(warehouseRepository: getIt()))
    ..registerFactory(
      () => PurchaseNoteListCubit(
        fetchPurchaseNotesUseCase: getIt(),
        deletePurchaseNoteUseCase: getIt(),
      ),
    )
    ..registerFactory(
      () => PurchaseNoteFormCubit(
        createPurchaseNoteUseCase: getIt(),
        updatePurchaseNoteUseCase: getIt(),
      ),
    )
    ..registerFactory(
      () => ImportPurchaseNoteCubit(
        importPurchaseNoteUseCase: getIt(),
        fileInteractionService: getIt(),
      ),
    )
    ..registerFactory(
      () => PurchaseNoteCostCubit(
        updateReturnCostUseCase: getIt(),
        addShippingFeeUseCase: getIt(),
      ),
    )
    ..registerFactory(
      () => PurchaseNoteDetailCubit(fetchPurchaseNoteUseCase: getIt()),
    );

  getIt
    ..registerLazySingleton(
      () => AppCubit(
        getRefreshTokenUseCase: getIt(),
        fetchUserFromStorageUseCase: getIt(),
      ),
    )
    ..registerLazySingleton(
      () => UserCubit(
        fetchUserUseCase: getIt(),
        fetchUserFromStorageUseCase: getIt(),
      ),
    )
    ..registerFactory(() => UpdateProfileCubit(updateProfileUseCase: getIt()))
    ..registerFactory(
      () => DropdownCubit(
        fetchSuppliersDropdownUseCase: getIt(),
        fetchPurchaseNotesDropdownUseCase: getIt(),
      ),
    );
}
