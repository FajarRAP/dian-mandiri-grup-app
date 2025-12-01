import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/respository_handler_mixin.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';
import '../../domain/repositories/warehouse_repository.dart';
import '../../domain/usecases/delete_purchase_note_use_case.dart';
import '../../domain/usecases/fetch_purchase_note_use_case.dart';
import '../../domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import '../../domain/usecases/fetch_purchase_notes_use_case.dart';
import '../../domain/usecases/insert_purchase_note_file_use_case.dart';
import '../../domain/usecases/create_purchase_note_use_case.dart';
import '../../domain/usecases/insert_return_cost_use_case.dart';
import '../../domain/usecases/insert_shipping_fee_use_case.dart';
import '../../domain/usecases/update_purchase_note_use_case.dart';
import '../datasources/warehouse_remote_data_source.dart';

class WarehouseRepositoryImpl
    with RepositoryHandlerMixin
    implements WarehouseRepository {
  const WarehouseRepositoryImpl({required this.warehouseRemoteDataSource});

  final WarehouseRemoteDataSource warehouseRemoteDataSource;

  @override
  Future<Either<Failure, String>> deletePurchaseNote(
    DeletePurchaseNoteUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await warehouseRemoteDataSource.deletePurchaseNote(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, PurchaseNoteDetailEntity>> fetchPurchaseNote(
    FetchPurchaseNoteUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<PurchaseNoteDetailEntity>(() async {
      final result = await warehouseRemoteDataSource.fetchPurchaseNote(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, List<PurchaseNoteSummaryEntity>>> fetchPurchaseNotes(
    FetchPurchaseNotesUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<List<PurchaseNoteSummaryEntity>>(
      () async {
        final result = await warehouseRemoteDataSource.fetchPurchaseNotes(
          params,
        );

        return result;
      },
    );
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchPurchaseNotesDropdown(
    FetchPurchaseNotesDropdownUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<List<DropdownEntity>>(() async {
      final result = await warehouseRemoteDataSource.fetchPurchaseNotesDropdown(
        params,
      );

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> insertPurchaseNoteFile(
    InsertPurchaseNoteFileUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(
      () async {
        final result = await warehouseRemoteDataSource.insertPurchaseNoteFile(
          params,
        );

        return result;
      },
      onServerException: (se) {
        if (se.code == 400) {
          if (List.from(se.errors?['data']['header'] ?? []).isNotEmpty) {
            return SpreadsheetFailure.fromJson(se.errors ?? {});
          }
        }

        return null;
      },
    );
  }

  @override
  Future<Either<Failure, String>> createPurchaseNote(
    CreatePurchaseNoteUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await warehouseRemoteDataSource.createPurchaseNote(
        params,
      );

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> insertReturnCost(
    InsertReturnCostUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await warehouseRemoteDataSource.insertReturnCost(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> insertShippingFee(
    InsertShippingFeeUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await warehouseRemoteDataSource.insertShippingFee(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> updatePurchaseNote(
    UpdatePurchaseNoteUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await warehouseRemoteDataSource.updatePurchaseNote(params);

      return result;
    });
  }
}
