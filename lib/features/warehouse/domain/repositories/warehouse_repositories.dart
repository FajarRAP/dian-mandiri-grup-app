import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../entities/insert_purchase_note_file_entity.dart';
import '../entities/insert_purchase_note_manual_entity.dart';
import '../entities/purchase_note_detail_entity.dart';
import '../entities/purchase_note_summary_entity.dart';

abstract class WarehouseRepositories {
  Future<Either<Failure, String>> deletePurchaseNote(
      {required String purchaseNoteId});
  Future<Either<Failure, PurchaseNoteDetailEntity>> fetchPurchaseNote(
      {required String purchaseNoteId});
  Future<Either<Failure, List<PurchaseNoteSummaryEntity>>> fetchPurchaseNotes({
    String column = 'name',
    String order = 'asc',
    String? search,
    int limit = 10,
    int page = 1,
  });
  Future<Either<Failure, List<DropdownEntity>>> fetchPurchaseNotesDropdown({
    String? search,
    int limit = 10,
    int page = 1,
  });
  Future<Either<Failure, String>> insertPurchaseNoteManual(
      {required InsertPurchaseNoteManualEntity purchaseNote});
  Future<Either<Failure, String>> insertPurchaseNoteFile(
      {required InsertPurchaseNoteFileEntity purchaseNote});
  Future<Either<Failure, String>> insertReturnCost(
      {required String purchaseNoteId, required int amount});
  Future<Either<Failure, String>> insertShippingFee(
      {required int price, required List<String> purchaseNoteIds});
  Future<Either<Failure, String>> updatePurchaseNote(
      {required InsertPurchaseNoteManualEntity purchaseNote});
}
