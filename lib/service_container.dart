import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'core/common/constants.dart';
import 'core/helpers/dio_interceptor.dart';
import 'features/auth/data/datasources/auth_remote_data_sources.dart';
import 'features/auth/data/repositories/auth_repositories_impl.dart';
import 'features/auth/domain/repositories/auth_repositories.dart';
import 'features/auth/domain/usecases/fetch_user_from_storage_use_case.dart';
import 'features/auth/domain/usecases/fetch_user_use_case.dart';
import 'features/auth/domain/usecases/refresh_token_use_case.dart';
import 'features/auth/domain/usecases/sign_in_use_case.dart';
import 'features/auth/domain/usecases/sign_out_use_case.dart';
import 'features/auth/domain/usecases/update_profile_use_case.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/supplier/data/datasources/supplier_remote_data_sources.dart';
import 'features/supplier/data/repositories/supplier_repositories_impl.dart';
import 'features/supplier/domain/repositories/supplier_repositories.dart';
import 'features/supplier/domain/usecases/fetch_supplier_use_case.dart';
import 'features/supplier/domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import 'features/supplier/domain/usecases/fetch_suppliers_use_case.dart';
import 'features/supplier/domain/usecases/insert_supplier_use_case.dart';
import 'features/supplier/domain/usecases/update_supplier_use_case.dart';
import 'features/supplier/presentation/cubit/supplier_cubit.dart';
import 'features/tracker/data/datasources/shipment_remote_data_sources.dart';
import 'features/tracker/data/repositories/shipment_repository_impl.dart';
import 'features/tracker/domain/repositories/shipment_repositories.dart';
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
import 'features/warehouse/data/datasources/warehouse_remote_data_sources.dart';
import 'features/warehouse/data/repositories/warehouse_repositories_impl.dart';
import 'features/warehouse/domain/repositories/warehouse_repositories.dart';
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

  // Auth
  getIt
    ..registerLazySingleton<AuthRemoteDataSources<Response>>(
        () => AuthRemoteDataSourcesImpl(dio: getIt.get()))
    ..registerLazySingleton<AuthRepositories>(() => AuthRepositoriesImpl(
        authRemoteDataSource: getIt.get(),
        googleSignIn: GoogleSignIn(),
        storage: getIt.get()))
    ..registerLazySingleton<AuthCubit>(() => AuthCubit(
        fetchUserUseCase: FetchUserUseCase(authRepositories: getIt.get()),
        fetchUserFromStorageUseCase:
            FetchUserFromStorageUseCase(authRepositories: getIt.get()),
        refreshTokenUseCase: RefreshTokenUseCase(authRepositories: getIt.get()),
        signInUseCase: SignInUseCase(authRepositories: getIt.get()),
        signOutUseCase: SignOutUseCase(authRepositories: getIt.get()),
        updateProfileUseCase:
            UpdateProfileUseCase(authRepositories: getIt.get())));

  // Ship
  getIt
    ..registerLazySingleton<ShipmentRemoteDataSources<Response>>(
        () => ShipmentRemoteDataSourcesImpl(dio: getIt.get()))
    ..registerLazySingleton<ShipmentRepositories>(
        () => ShipmentRepositoriesImpl(shipmentRemoteDataSources: getIt.get()))
    ..registerLazySingleton<ShipmentCubit>(() => ShipmentCubit(
        createShipmentReportUseCase:
            CreateShipmentReportUseCase(shipmentRepositories: getIt.get()),
        deleteShipmentUseCase:
            DeleteShipmentUseCase(shipmentRepositories: getIt.get()),
        fetchShipmentByIdUseCase:
            FetchShipmentByIdUseCase(shipmentRepositories: getIt.get()),
        fetchShipmentByReceiptNumberUseCase:
            FetchShipmentByReceiptNumberUseCase(
                shipmentRepositories: getIt.get()),
        fetchShipmentReportsUseCase:
            FetchShipmentReportsUseCase(shipmentRepositories: getIt.get()),
        fetchShipmentsUseCase:
            FetchShipmentsUseCase(shipmentRepositories: getIt.get()),
        insertShipmentDocumentUseCase:
            InsertShipmentDocumentUseCase(shipmentRepositories: getIt.get()),
        insertShipmentUseCase:
            InsertShipmentUseCase(shipmentRepositories: getIt.get()),
        downloadShipmentReportUseCase:
            DownloadShipmentReportUseCase(shipmentRepositories: getIt.get())));

  // Supplier
  getIt
    ..registerLazySingleton<SupplierRemoteDataSources<Response>>(
        () => SupplierRemoteDataSourcesImpl(dio: getIt.get()))
    ..registerLazySingleton<SupplierRepositories>(
        () => SupplierRepositoriesImpl(supplierRemoteDataSources: getIt.get()))
    ..registerLazySingleton<SupplierCubit>(() => SupplierCubit(
        fetchSupplierUseCase:
            FetchSupplierUseCase(supplierRepositories: getIt.get()),
        fetchSuppliersUseCase:
            FetchSuppliersUseCase(supplierRepositories: getIt.get()),
        fetchSuppliersDropdownUseCase:
            FetchSuppliersDropdownUseCase(supplierRepositories: getIt.get()),
        insertSupplierUseCase:
            InsertSupplierUseCase(supplierRepositories: getIt.get()),
        updateSupplierUseCase:
            UpdateSupplierUseCase(supplierRepositories: getIt.get())));

  // Warehouse
  getIt
    ..registerLazySingleton<WarehouseRemoteDataSources<Response>>(
        () => WarehouseRemoteDataSourcesImpl(dio: getIt.get()))
    ..registerLazySingleton<WarehouseRepositories>(() =>
        WarehouseRepositoriesImpl(warehouseRemoteDataSources: getIt.get()))
    ..registerLazySingleton<WarehouseCubit>(() => WarehouseCubit(
        deletePurchaseNoteUseCase:
            DeletePurchaseNoteUseCase(warehouseRepositories: getIt.get()),
        fetchPurchaseNoteUseCase:
            FetchPurchaseNoteUseCase(warehouseRepositories: getIt.get()),
        fetchPurchaseNotesUseCase:
            FetchPurchaseNotesUseCase(warehouseRepositories: getIt.get()),
        fetchPurchaseNotesDropdownUseCase: FetchPurchaseNotesDropdownUseCase(
            warehouseRepositories: getIt.get()),
        insertPurchaseNoteManualUseCase:
            InsertPurchaseNoteManualUseCase(warehouseRepositories: getIt.get()),
        insertPurchaseNoteFileUseCase:
            InsertPurchaseNoteFileUseCase(warehouseRepositories: getIt.get()),
        insertReturnCostUseCase:
            InsertReturnCostUseCase(warehouseRepositories: getIt.get()),
        insertShippingFeeUseCase:
            InsertShippingFeeUseCase(warehouseRepositories: getIt.get()),
        updatePurchaseNoteUseCase:
            UpdatePurchaseNoteUseCase(warehouseRepositories: getIt.get())));
}
