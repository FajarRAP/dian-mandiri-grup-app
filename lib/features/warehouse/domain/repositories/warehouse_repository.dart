import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/dropdown_entity.dart';
import '../../../../core/errors/failure.dart';
import '../entities/purchase_note_detail_entity.dart';
import '../entities/purchase_note_summary_entity.dart';
import '../usecases/delete_purchase_note_use_case.dart';
import '../usecases/fetch_purchase_note_use_case.dart';
import '../usecases/fetch_purchase_notes_dropdown_use_case.dart';
import '../usecases/fetch_purchase_notes_use_case.dart';
import '../usecases/import_purchase_note_use_case.dart';
import '../usecases/create_purchase_note_use_case.dart';
import '../usecases/update_return_cost_use_case.dart';
import '../usecases/add_shipping_fee_use_case.dart';
import '../usecases/update_purchase_note_use_case.dart';

abstract class WarehouseRepository {
  Future<Either<Failure, String>> deletePurchaseNote(
    DeletePurchaseNoteUseCaseParams params,
  );
  Future<Either<Failure, PurchaseNoteDetailEntity>> fetchPurchaseNote(
    FetchPurchaseNoteUseCaseParams params,
  );
  Future<Either<Failure, List<PurchaseNoteSummaryEntity>>> fetchPurchaseNotes(
    FetchPurchaseNotesUseCaseParams params,
  );
  Future<Either<Failure, List<DropdownEntity>>> fetchPurchaseNotesDropdown(
    FetchPurchaseNotesDropdownUseCaseParams params,
  );
  Future<Either<Failure, String>> createPurchaseNote(
    CreatePurchaseNoteUseCaseParams params,
  );
  Future<Either<Failure, String>> importPurchaseNote(
    ImportPurchaseNoteUseCaseParams params,
  );
  Future<Either<Failure, String>> updateReturnCost(
    UpdateReturnCostUseCaseParams params,
  );
  Future<Either<Failure, String>> addShippingFee(
    AddShippingFeeUseCaseParams params,
  );
  Future<Either<Failure, String>> updatePurchaseNote(
    UpdatePurchaseNoteUseCaseParams params,
  );
}
