import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';
import 'package:ship_tracker/features/tracker/domain/usecases/delete_ship_use_case.dart';
import 'package:ship_tracker/features/tracker/domain/usecases/get_receipt_status_use_case.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repositories_impl.dart';
import 'features/auth/domain/repositories/auth_repositories.dart';
import 'features/auth/domain/usecases/login_use_case.dart';
import 'features/auth/domain/usecases/logout_use_case.dart';
import 'features/auth/domain/usecases/register_use_case.dart';
import 'features/auth/domain/usecases/reset_password_use_case.dart';
import 'features/auth/domain/usecases/send_password_reset_token_use_case.dart';
import 'features/auth/domain/usecases/update_user_use_case.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/tracker/data/datasources/ship_local_data_source.dart';
import 'features/tracker/data/datasources/ship_remote_data_source.dart';
import 'features/tracker/data/repositories/ship_repositories_impl.dart';
import 'features/tracker/domain/repositories/ship_repositories.dart';
import 'features/tracker/domain/usecases/create_report_use_case.dart';
import 'features/tracker/domain/usecases/get_all_spreadsheet_files_use_case.dart';
import 'features/tracker/domain/usecases/get_image_url_use_case.dart';
import 'features/tracker/domain/usecases/get_ships_use_case.dart';
import 'features/tracker/domain/usecases/insert_ship_use_case.dart';
import 'features/tracker/domain/usecases/upload_image_use_case.dart';
import 'features/tracker/presentation/cubit/ship_cubit.dart';

final getIt = GetIt.instance;

void setup({required CameraDescription camera}) {
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Auth
  getIt
    ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(supabase: getIt.get()))
    ..registerLazySingleton<AuthRepositories>(
        () => AuthRepositoriesImpl(authRemote: getIt.get()))
    ..registerLazySingleton(() => AuthCubit(
        loginUseCase: LoginUseCase(authRepo: getIt.get()),
        registerUseCase: RegisterUseCase(authRepo: getIt.get()),
        logoutUseCase: LogoutUseCase(authRepo: getIt.get()),
        updateUserUseCase: UpdateUserUseCase(getIt.get()),
        sendPasswordResetTokenUseCase:
            SendPasswordResetTokenUseCase(getIt.get()),
        resetPasswordUseCase: ResetPasswordUseCase(getIt.get())));

  // Ship
  getIt
    ..registerLazySingleton<ShipRemoteDataSource>(() =>
        ShipRemoteDataSourceImpl(supabase: getIt.get(), environment: 'dev'))
    ..registerLazySingleton<ShipLocalDataSource>(
        () => ShipLocalDataSourceImpl())
    ..registerLazySingleton<ShipRepositories>(() =>
        ShipRepositoriesImpl(shipRemote: getIt.get(), shipLocal: getIt.get()))
    ..registerLazySingleton(() => ShipCubit(
        getShipsUseCase: GetShipsUseCase(shipRepo: getIt.get()),
        insertShipUseCase: InsertShipUseCase(shipRepo: getIt.get()),
        deleteShipUseCase: DeleteShipUseCase(shipRepo: getIt.get()),
        createReportUseCase: CreateReportUseCase(shipRepo: getIt.get()),
        getAllSpreadsheetFilesUseCase:
            GetAllSpreadsheetFilesUseCase(shipRepo: getIt.get()),
        getImageUrlUseCase: GetImageUrlUseCase(shipRepo: getIt.get()),
        uploadImageUseCase: UploadImageUseCase(shipRepo: getIt.get()),
        getReceiptStatusUseCase: GetReceiptStatusUseCase(shipRepo: getIt.get()),
        camera: camera));
}
