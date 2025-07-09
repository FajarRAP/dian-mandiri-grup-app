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
    required InsertShippingFeeUseCase insertShippingFeeUseCase,
    required UpdatePurchaseNoteUseCase updatePurchaseNoteUseCase,
  })  : _deletePurchaseNoteUseCase = deletePurchaseNoteUseCase,
        _fetchPurchaseNoteUseCase = fetchPurchaseNoteUseCase,
        _fetchPurchaseNotesUseCase = fetchPurchaseNotesUseCase,
        _fetchPurchaseNotesDropdownUseCase = fetchPurchaseNotesDropdownUseCase,
        _insertPurchaseNoteManualUseCase = insertPurchaseNoteManualUseCase,
        _insertPurchaseNoteFileUseCase = insertPurchaseNoteFileUseCase,
        _insertShippingFeeUseCase = insertShippingFeeUseCase,
        _updatePurchaseNoteUseCase = updatePurchaseNoteUseCase,
        super(WarehouseInitial());

  final DeletePurchaseNoteUseCase _deletePurchaseNoteUseCase;
  final FetchPurchaseNoteUseCase _fetchPurchaseNoteUseCase;
  final FetchPurchaseNotesUseCase _fetchPurchaseNotesUseCase;
  final FetchPurchaseNotesDropdownUseCase _fetchPurchaseNotesDropdownUseCase;
  final InsertPurchaseNoteManualUseCase _insertPurchaseNoteManualUseCase;
  final InsertPurchaseNoteFileUseCase _insertPurchaseNoteFileUseCase;
  final InsertShippingFeeUseCase _insertShippingFeeUseCase;
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

  Future<void> fetchPurchaseNotesDropdown({
    String? search,
  }) async {
    emit(FetchPurchaseNotesDropdownLoading());
    final result = await _fetchPurchaseNotesDropdownUseCase({
      'search': search,
    });
    result.fold(
      (l) => emit(FetchPurchaseNotesDropdownError(message: l.message)),
      (r) => emit(FetchPurchaseNotesDropdownLoaded(purchaseNotes: r)),
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
      (l) => emit(InsertPurchaseNoteFileError(failure: l)),
      (r) => emit(InsertPurchaseNoteFileLoaded(message: r)),
    );
  }

  Future<void> insertShippingFee({
    required int price,
    required List<String> purchaseNoteIds,
  }) async {
    emit(InsertShippingFeeLoading());

    final result = await _insertShippingFeeUseCase({
      'price': price,
      'purchase_note_ids': purchaseNoteIds,
    });

    result.fold(
      (l) => emit(InsertShippingFeeError(message: l.message)),
      (r) => emit(InsertShippingFeeLoaded(message: r)),
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
