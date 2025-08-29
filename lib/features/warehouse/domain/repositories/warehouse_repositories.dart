import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../entities/insert_purchase_note_file_entity.dart';
import '../entities/insert_purchase_note_manual_entity.dart';
import '../entities/purchase_note_detail_entity.dart';
import '../entities/purchase_note_summary_entity.dart';
import '../usecases/fetch_purchase_notes_dropdown_use_case.dart';
import '../usecases/fetch_purchase_notes_use_case.dart';
import '../usecases/insert_return_cost_use_case.dart';
import '../usecases/insert_shipping_fee_use_case.dart';
import '../usecases/update_purchase_note_use_case.dart';

abstract class WarehouseRepositories {
  Future<Either<Failure, String>> deletePurchaseNote(
      {required String purchaseNoteId});
  Future<Either<Failure, PurchaseNoteDetailEntity>> fetchPurchaseNote(
      {required String purchaseNoteId});
  Future<Either<Failure, List<PurchaseNoteSummaryEntity>>> fetchPurchaseNotes(
      {required FetchPurchaseNotesUseCaseParams params});
  Future<Either<Failure, List<DropdownEntity>>> fetchPurchaseNotesDropdown(
      {required FetchPurchaseNotesDropdownUseCaseParams params});
  Future<Either<Failure, String>> insertPurchaseNoteManual(
      {required InsertPurchaseNoteManualEntity purchaseNote});
  Future<Either<Failure, String>> insertPurchaseNoteFile(
      {required InsertPurchaseNoteFileEntity purchaseNote});
  Future<Either<Failure, String>> insertReturnCost(
      {required InsertReturnCostUseCaseParams params});
  Future<Either<Failure, String>> insertShippingFee(
      {required InsertShippingFeeUseCaseParams params});
  Future<Either<Failure, String>> updatePurchaseNote(
      {required UpdatePurchaseNoteUseCaseParams params});
}
