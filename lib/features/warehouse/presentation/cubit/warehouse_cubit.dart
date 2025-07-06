import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ship_tracker/features/warehouse/domain/entities/purchase_note_detail_entity.dart';
import 'package:ship_tracker/features/warehouse/domain/entities/purchase_note_summary_entity.dart';

import '../../domain/entities/insert_purchase_note_file_entity.dart';
import '../../domain/entities/insert_purchase_note_manual_entity.dart';
import '../../domain/usecases/delete_purchase_note_use_case.dart';
import '../../domain/usecases/fetch_purchase_note_use_case.dart';
import '../../domain/usecases/fetch_purchase_notes_use_case.dart';
import '../../domain/usecases/insert_purchase_note_file_use_case.dart';
import '../../domain/usecases/insert_purchase_note_manual_use_case.dart';
import '../../domain/usecases/update_purchase_note_use_case.dart';

part 'warehouse_state.dart';

class WarehouseCubit extends Cubit<WarehouseState> {
  WarehouseCubit({
    required DeletePurchaseNoteUseCase deletePurchaseNoteUseCase,
    required FetchPurchaseNoteUseCase fetchPurchaseNoteUseCase,
    required FetchPurchaseNotesUseCase fetchPurchaseNotesUseCase,
    required InsertPurchaseNoteManualUseCase insertPurchaseNoteManualUseCase,
    required InsertPurchaseNoteFileUseCase insertPurchaseNoteFileUseCase,
    required UpdatePurchaseNoteUseCase updatePurchaseNoteUseCase,
  })  : _deletePurchaseNoteUseCase = deletePurchaseNoteUseCase,
        _fetchPurchaseNoteUseCase = fetchPurchaseNoteUseCase,
        _fetchPurchaseNotesUseCase = fetchPurchaseNotesUseCase,
        _insertPurchaseNoteManualUseCase = insertPurchaseNoteManualUseCase,
        _insertPurchaseNoteFileUseCase = insertPurchaseNoteFileUseCase,
        _updatePurchaseNoteUseCase = updatePurchaseNoteUseCase,
        super(WarehouseInitial());

  final DeletePurchaseNoteUseCase _deletePurchaseNoteUseCase;
  final FetchPurchaseNoteUseCase _fetchPurchaseNoteUseCase;
  final FetchPurchaseNotesUseCase _fetchPurchaseNotesUseCase;
  final InsertPurchaseNoteManualUseCase _insertPurchaseNoteManualUseCase;
  final InsertPurchaseNoteFileUseCase _insertPurchaseNoteFileUseCase;
  final UpdatePurchaseNoteUseCase _updatePurchaseNoteUseCase;

  Future<void> deletePurchaseNote({required String purchaseNoteId}) async {
    emit(DeletePurchaseNoteLoading());

    final result = await _deletePurchaseNoteUseCase(purchaseNoteId);

    result.fold(
      (l) => emit(DeletePurchaseNoteError(message: l.message)),
      (r) => emit(DeletePurchaseNoteLoaded(message: r)),
    );
  }

  Future<void> fetchPurchaseNote({required String purchaseNoteId}) async {
    emit(FetchPurchaseNoteLoading());

    final result = await _fetchPurchaseNoteUseCase(purchaseNoteId);

    result.fold(
      (l) => emit(FetchPurchaseNoteError(message: l.message)),
      (r) => emit(FetchPurchaseNoteLoaded(purchaseNote: r)),
    );
  }

  Future<void> fetchPurchaseNotes({
    String? search,
    String column = 'name',
    String sort = 'asc',
  }) async {
    emit(FetchPurchaseNotesLoading());
    final result = await _fetchPurchaseNotesUseCase({
      'search': search,
      'column': column,
      'sort': sort,
    });
    result.fold(
      (l) => emit(FetchPurchaseNotesError(message: l.message)),
      (r) => emit(FetchPurchaseNotesLoaded(purchaseNotes: r)),
    );
  }

  Future<void> insertPurchaseNoteManual(
      {required InsertPurchaseNoteManualEntity purchaseNote}) async {
    emit(InsertPurchaseNoteManualLoading());

    final result = await _insertPurchaseNoteManualUseCase(purchaseNote);
    result.fold(
      (l) => emit(InsertPurchaseNoteManualError(message: l.message)),
      (r) => emit(InsertPurchaseNoteManualLoaded(message: r)),
    );
  }

  Future<void> insertPurchaseNoteFile({
    required InsertPurchaseNoteFileEntity purchaseNote,
  }) async {
    emit(InsertPurchaseNoteFileLoading());

    final result = await _insertPurchaseNoteFileUseCase(purchaseNote);

    result.fold(
      (l) => emit(InsertPurchaseNoteFileError(message: l.message)),
      (r) => emit(InsertPurchaseNoteFileLoaded(message: r)),
    );
  }

  Future<void> updatePurchaseNote({
    required InsertPurchaseNoteManualEntity purchaseNote,
  }) async {
    emit(UpdatePurchaseNoteLoading());

    final result = await _updatePurchaseNoteUseCase(purchaseNote);

    result.fold(
      (l) => emit(UpdatePurchaseNoteError(message: l.message)),
      (r) => emit(UpdatePurchaseNoteLoaded(message: r)),
    );
  }
}
