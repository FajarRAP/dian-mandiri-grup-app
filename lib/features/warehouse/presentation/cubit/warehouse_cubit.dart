import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';
import '../../domain/entities/warehouse_item_entity.dart';
import '../../domain/usecases/fetch_purchase_note_use_case.dart';
import '../../domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import '../../domain/usecases/insert_purchase_note_file_use_case.dart';
import '../../domain/usecases/insert_purchase_note_manual_use_case.dart';
import '../../domain/usecases/insert_return_cost_use_case.dart';
import '../../domain/usecases/insert_shipping_fee_use_case.dart';
import '../../domain/usecases/update_purchase_note_use_case.dart';

part 'warehouse_state.dart';

class WarehouseCubit extends Cubit<WarehouseState> {
  WarehouseCubit({
    required FetchPurchaseNoteUseCase fetchPurchaseNoteUseCase,
    required FetchPurchaseNotesDropdownUseCase
    fetchPurchaseNotesDropdownUseCase,
    required InsertPurchaseNoteManualUseCase insertPurchaseNoteManualUseCase,
    required InsertPurchaseNoteFileUseCase insertPurchaseNoteFileUseCase,
    required InsertReturnCostUseCase insertReturnCostUseCase,
    required InsertShippingFeeUseCase insertShippingFeeUseCase,
    required UpdatePurchaseNoteUseCase updatePurchaseNoteUseCase,
    required ImagePickerService imagePickerService,
  }) : _fetchPurchaseNoteUseCase = fetchPurchaseNoteUseCase,
       _fetchPurchaseNotesDropdownUseCase = fetchPurchaseNotesDropdownUseCase,
       _insertPurchaseNoteManualUseCase = insertPurchaseNoteManualUseCase,
       _insertPurchaseNoteFileUseCase = insertPurchaseNoteFileUseCase,
       _insertReturnCostUseCase = insertReturnCostUseCase,
       _insertShippingFeeUseCase = insertShippingFeeUseCase,
       _updatePurchaseNoteUseCase = updatePurchaseNoteUseCase,
       _imagePickerService = imagePickerService,
       super(WarehouseInitial());

  final FetchPurchaseNoteUseCase _fetchPurchaseNoteUseCase;
  final FetchPurchaseNotesDropdownUseCase _fetchPurchaseNotesDropdownUseCase;
  final InsertPurchaseNoteManualUseCase _insertPurchaseNoteManualUseCase;
  final InsertPurchaseNoteFileUseCase _insertPurchaseNoteFileUseCase;
  final InsertReturnCostUseCase _insertReturnCostUseCase;
  final InsertShippingFeeUseCase _insertShippingFeeUseCase;
  final UpdatePurchaseNoteUseCase _updatePurchaseNoteUseCase;
  final ImagePickerService _imagePickerService;

  var _currentPage = 1;
  final _purchaseNotesDropdown = <DropdownEntity>[];

  Future<void> fetchPurchaseNote({required String purchaseNoteId}) async {
    emit(FetchPurchaseNoteLoading());

    final params = FetchPurchaseNoteUseCaseParams(
      purchaseNoteId: purchaseNoteId,
    );
    final result = await _fetchPurchaseNoteUseCase(params);

    result.fold(
      (failure) => emit(FetchPurchaseNoteError(message: failure.message)),
      (purchaseNote) =>
          emit(FetchPurchaseNoteLoaded(purchaseNote: purchaseNote)),
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
      (purchaseNotesDropdown) => emit(
        FetchPurchaseNotesDropdownLoaded(
          purchaseNotes: _purchaseNotesDropdown
            ..clear()
            ..addAll(purchaseNotesDropdown),
        ),
      ),
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
          emit(ListPaginateLast(_currentPage = 1));
        } else {
          emit(ListPaginateLoaded());
          emit(
            FetchPurchaseNotesDropdownLoaded(
              purchaseNotes: _purchaseNotesDropdown
                ..addAll(purchaseNotesDropdown),
            ),
          );
        }
      },
    );
  }

  Future<void> insertPurchaseNoteManual({
    required InsertPurchaseNoteManualUseCaseParams purchaseNote,
  }) async {
    emit(InsertPurchaseNoteManualLoading());

    final result = await _insertPurchaseNoteManualUseCase(purchaseNote);

    result.fold(
      (failure) =>
          emit(InsertPurchaseNoteManualError(message: failure.message)),
      (message) => emit(InsertPurchaseNoteManualLoaded(message: message)),
    );
  }

  Future<void> insertPurchaseNoteFile({
    required InsertPurchaseNoteFileUseCaseParams purchaseNote,
  }) async {
    emit(InsertPurchaseNoteFileLoading());

    final result = await _insertPurchaseNoteFileUseCase(purchaseNote);

    result.fold(
      (failure) => emit(InsertPurchaseNoteFileError(failure: failure)),
      (message) => emit(InsertPurchaseNoteFileLoaded(message: message)),
    );
  }

  Future<void> insertReturnCost({
    required String purchaseNoteId,
    required int amount,
  }) async {
    emit(InsertReturnCostLoading());

    final params = InsertReturnCostUseCaseParams(
      purchaseNoteId: purchaseNoteId,
      amount: amount,
    );
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
      price: price,
      purchaseNoteIds: purchaseNoteIds,
    );
    final result = await _insertShippingFeeUseCase(params);

    result.fold(
      (failure) => emit(InsertShippingFeeError(message: failure.message)),
      (message) => emit(InsertShippingFeeLoaded(message: message)),
    );
  }

  Future<void> updatePurchaseNote({
    required String purchaseNoteId,
    required DateTime date,
    required String receipt,
    required String? note,
    required String supplierId,
    required List<WarehouseItemEntity> items,
  }) async {
    emit(UpdatePurchaseNoteLoading());

    final params = UpdatePurchaseNoteUseCaseParams(
      purchaseNoteId: purchaseNoteId,
      date: date,
      receipt: receipt,
      note: note,
      supplierId: supplierId,
      items: items,
    );
    final result = await _updatePurchaseNoteUseCase(params);

    result.fold(
      (failure) => emit(UpdatePurchaseNoteError(message: failure.message)),
      (message) => emit(UpdatePurchaseNoteLoaded(message: message)),
    );
  }

  Future<void> pickNewPurchaseNoteImage(PickImageSource source) async {
    if (state is! FetchPurchaseNoteLoaded) return;
    final currentState = state as FetchPurchaseNoteLoaded;

    final pickedImage = switch (source) {
      PickImageSource.camera => await _imagePickerService.pickImageFromCamera(),
      PickImageSource.gallery =>
        await _imagePickerService.pickImageFromGallery(),
    };
    if (pickedImage == null) return;

    emit(currentState.copyWith(pickedImage: pickedImage));
  }

  void deletePurchaseNoteItem(int index) {
    if (state is! FetchPurchaseNoteLoaded) return;
    final currentState = state as FetchPurchaseNoteLoaded;

    final newItems = List<WarehouseItemEntity>.from(
      currentState.purchaseNote.items,
    )..removeAt(index);
    final updatedPurchaseNote = currentState.purchaseNote.copyWith(
      items: newItems,
    );
    emit(currentState.copyWith(purchaseNote: updatedPurchaseNote));
  }

  void editPurchaseNoteItem(int index, WarehouseItemEntity item) {
    if (state is! FetchPurchaseNoteLoaded) return;
    final currentState = state as FetchPurchaseNoteLoaded;

    final newItems =
        List<WarehouseItemEntity>.from(currentState.purchaseNote.items)
          ..removeAt(index)
          ..insert(index, item);
    final updatedPurchaseNote = currentState.purchaseNote.copyWith(
      items: newItems,
    );
    emit(currentState.copyWith(purchaseNote: updatedPurchaseNote));
  }

  Future<void> updatePurchaseNoteReturnCost(int returnCost) async {
    if (state is! FetchPurchaseNoteLoaded) return;
    final currentState = state as FetchPurchaseNoteLoaded;

    emit(InsertReturnCostLoading());

    final params = InsertReturnCostUseCaseParams(
      purchaseNoteId: currentState.purchaseNote.id,
      amount: returnCost,
    );
    final result = await _insertReturnCostUseCase(params);

    result.fold(
      (failure) => emit(InsertReturnCostError(message: failure.message)),
      (message) {
        final updatedPurchaseNote = currentState.purchaseNote.copyWith(
          returnCost: returnCost,
        );
        emit(InsertReturnCostLoaded(message: message));
        emit(currentState.copyWith(purchaseNote: updatedPurchaseNote));
      },
    );
  }
}
