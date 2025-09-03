import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/insert_purchase_note_file_entity.dart';
import '../../domain/entities/insert_purchase_note_manual_entity.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';
import '../../domain/usecases/delete_purchase_note_use_case.dart';
import '../../domain/usecases/fetch_purchase_note_use_case.dart';
import '../../domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import '../../domain/usecases/fetch_purchase_notes_use_case.dart';
import '../../domain/usecases/insert_purchase_note_file_use_case.dart';
import '../../domain/usecases/insert_purchase_note_manual_use_case.dart';
import '../../domain/usecases/insert_return_cost_use_case.dart';
import '../../domain/usecases/insert_shipping_fee_use_case.dart';
import '../../domain/usecases/update_purchase_note_use_case.dart';

part 'warehouse_state.dart';

class WarehouseCubit extends Cubit<WarehouseState> {
  WarehouseCubit({
    required DeletePurchaseNoteUseCase deletePurchaseNoteUseCase,
    required FetchPurchaseNoteUseCase fetchPurchaseNoteUseCase,
    required FetchPurchaseNotesUseCase fetchPurchaseNotesUseCase,
    required FetchPurchaseNotesDropdownUseCase
        fetchPurchaseNotesDropdownUseCase,
    required InsertPurchaseNoteManualUseCase insertPurchaseNoteManualUseCase,
    required InsertPurchaseNoteFileUseCase insertPurchaseNoteFileUseCase,
    required InsertReturnCostUseCase insertReturnCostUseCase,
    required InsertShippingFeeUseCase insertShippingFeeUseCase,
    required UpdatePurchaseNoteUseCase updatePurchaseNoteUseCase,
  })  : _deletePurchaseNoteUseCase = deletePurchaseNoteUseCase,
        _fetchPurchaseNoteUseCase = fetchPurchaseNoteUseCase,
        _fetchPurchaseNotesUseCase = fetchPurchaseNotesUseCase,
        _fetchPurchaseNotesDropdownUseCase = fetchPurchaseNotesDropdownUseCase,
        _insertPurchaseNoteManualUseCase = insertPurchaseNoteManualUseCase,
        _insertPurchaseNoteFileUseCase = insertPurchaseNoteFileUseCase,
        _insertReturnCostUseCase = insertReturnCostUseCase,
        _insertShippingFeeUseCase = insertShippingFeeUseCase,
        _updatePurchaseNoteUseCase = updatePurchaseNoteUseCase,
        super(WarehouseInitial());

  final DeletePurchaseNoteUseCase _deletePurchaseNoteUseCase;
  final FetchPurchaseNoteUseCase _fetchPurchaseNoteUseCase;
  final FetchPurchaseNotesUseCase _fetchPurchaseNotesUseCase;
  final FetchPurchaseNotesDropdownUseCase _fetchPurchaseNotesDropdownUseCase;
  final InsertPurchaseNoteManualUseCase _insertPurchaseNoteManualUseCase;
  final InsertPurchaseNoteFileUseCase _insertPurchaseNoteFileUseCase;
  final InsertReturnCostUseCase _insertReturnCostUseCase;
  final InsertShippingFeeUseCase _insertShippingFeeUseCase;
  final UpdatePurchaseNoteUseCase _updatePurchaseNoteUseCase;

  var _currentPage = 1;
  final _purchaseNotes = <PurchaseNoteSummaryEntity>[];
  final _purchaseNotesDropdown = <DropdownEntity>[];

  Future<void> deletePurchaseNote({required String purchaseNoteId}) async {
    emit(DeletePurchaseNoteLoading());

    final result = await _deletePurchaseNoteUseCase(purchaseNoteId);

    result.fold(
      (failure) => emit(DeletePurchaseNoteError(message: failure.message)),
      (message) => emit(DeletePurchaseNoteLoaded(message: message)),
    );
  }

  Future<void> fetchPurchaseNote({required String purchaseNoteId}) async {
    emit(FetchPurchaseNoteLoading());

    final result = await _fetchPurchaseNoteUseCase(purchaseNoteId);

    result.fold(
      (failure) => emit(FetchPurchaseNoteError(message: failure.message)),
      (purchaseNote) =>
          emit(FetchPurchaseNoteLoaded(purchaseNote: purchaseNote)),
    );
  }

  Future<void> fetchPurchaseNotes({
    String? search,
    String column = 'created_at',
    String sort = 'asc',
  }) async {
    _currentPage = 1;

    emit(FetchPurchaseNotesLoading());

    final params = FetchPurchaseNotesUseCaseParams(
      column: column,
      search: search,
      sort: sort,
      page: _currentPage,
    );
    final result = await _fetchPurchaseNotesUseCase(params);

    result.fold(
      (failure) => emit(FetchPurchaseNotesError(message: failure.message)),
      (purchaseNotes) => emit(FetchPurchaseNotesLoaded(
          purchaseNotes: _purchaseNotes
            ..clear()
            ..addAll(purchaseNotes))),
    );
  }

  Future<void> fetchPurchaseNotesPaginate({
    String? search,
    String column = 'created_at',
    String sort = 'asc',
  }) async {
    emit(ListPaginateLoading());

    final params = FetchPurchaseNotesUseCaseParams(
      column: column,
      search: search,
      sort: sort,
      page: ++_currentPage,
    );
    final result = await _fetchPurchaseNotesUseCase(params);

    result.fold(
      (failure) => emit(FetchPurchaseNotesError(message: failure.message)),
      (purchaseNotes) {
        if (purchaseNotes.isEmpty) {
          _currentPage = 1;
          emit(ListPaginateLast());
        } else {
          emit(ListPaginateLoaded());
          emit(FetchPurchaseNotesLoaded(
              purchaseNotes: _purchaseNotes..addAll(purchaseNotes)));
        }
      },
    );
  }

  Future<void> fetchPurchaseNotesDropdown({String? search}) async {
    _currentPage = 1;

    emit(FetchPurchaseNotesDropdownLoading());

    final params = FetchPurchaseNotesDropdownUseCaseParams(
      search: search,
      page: _currentPage,
    );
    final result = await _fetchPurchaseNotesDropdownUseCase(params);

    result.fold(
      (failure) =>
          emit(FetchPurchaseNotesDropdownError(message: failure.message)),
      (purchaseNotesDropdown) => emit(FetchPurchaseNotesDropdownLoaded(
          purchaseNotes: _purchaseNotesDropdown
            ..clear()
            ..addAll(purchaseNotesDropdown))),
    );
  }

  Future<void> fetchPurchaseNotesDropdownPaginate({String? search}) async {
    emit(ListPaginateLoading());

    final params = FetchPurchaseNotesDropdownUseCaseParams(
      search: search,
      page: ++_currentPage,
    );
    final result = await _fetchPurchaseNotesDropdownUseCase(params);

    result.fold(
      (failure) =>
          emit(FetchPurchaseNotesDropdownError(message: failure.message)),
      (purchaseNotesDropdown) {
        if (purchaseNotesDropdown.isEmpty) {
          _currentPage = 1;
          emit(ListPaginateLast());
        } else {
          emit(ListPaginateLoaded());
          emit(FetchPurchaseNotesDropdownLoaded(
              purchaseNotes: _purchaseNotesDropdown
                ..addAll(purchaseNotesDropdown)));
        }
      },
    );
  }

  Future<void> insertPurchaseNoteManual(
      {required InsertPurchaseNoteManualEntity purchaseNote}) async {
    emit(InsertPurchaseNoteManualLoading());

    final result = await _insertPurchaseNoteManualUseCase(purchaseNote);

    result.fold(
      (failure) =>
          emit(InsertPurchaseNoteManualError(message: failure.message)),
      (message) => emit(InsertPurchaseNoteManualLoaded(message: message)),
    );
  }

  Future<void> insertPurchaseNoteFile({
    required InsertPurchaseNoteFileEntity purchaseNote,
  }) async {
    emit(InsertPurchaseNoteFileLoading());

    final result = await _insertPurchaseNoteFileUseCase(purchaseNote);

    result.fold(
      (failure) => emit(InsertPurchaseNoteFileError(failure: failure)),
      (message) => emit(InsertPurchaseNoteFileLoaded(message: message)),
    );
  }

  Future<void> insertReturnCost(
      {required String purchaseNoteId, required int amount}) async {
    emit(InsertReturnCostLoading());

    final params = InsertReturnCostUseCaseParams(
        purchaseNoteId: purchaseNoteId, amount: amount);
    final result = await _insertReturnCostUseCase(params);

    result.fold(
      (failure) => emit(InsertReturnCostError(message: failure.message)),
      (message) => emit(InsertReturnCostLoaded(message: message)),
    );
  }

  Future<void> insertShippingFee({
    required int price,
    required List<String> purchaseNoteIds,
  }) async {
    emit(InsertShippingFeeLoading());

    final params = InsertShippingFeeUseCaseParams(
        price: price, purchaseNoteIds: purchaseNoteIds);
    final result = await _insertShippingFeeUseCase(params);

    result.fold(
      (failure) => emit(InsertShippingFeeError(message: failure.message)),
      (message) => emit(InsertShippingFeeLoaded(message: message)),
    );
  }

  Future<void> updatePurchaseNote({
    required String purchaseNoteId,
    required InsertPurchaseNoteManualEntity purchaseNote,
  }) async {
    emit(UpdatePurchaseNoteLoading());

    final params = UpdatePurchaseNoteUseCaseParams(
      purchaseNoteId: purchaseNoteId,
      purchaseNote: purchaseNote,
    );
    final result = await _updatePurchaseNoteUseCase(params);

    result.fold(
      (failure) => emit(UpdatePurchaseNoteError(message: failure.message)),
      (message) => emit(UpdatePurchaseNoteLoaded(message: message)),
    );
  }
}
