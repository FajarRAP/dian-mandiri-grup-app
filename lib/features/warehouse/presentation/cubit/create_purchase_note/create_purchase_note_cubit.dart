import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/common/dropdown_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/entities/purchase_note_detail_entity.dart';
import '../../../domain/entities/warehouse_item_entity.dart';
import '../../../domain/usecases/create_purchase_note_use_case.dart';
import '../../../domain/usecases/update_purchase_note_use_case.dart';

part 'create_purchase_note_state.dart';

class CreatePurchaseNoteCubit extends Cubit<CreatePurchaseNoteState> {
  CreatePurchaseNoteCubit({
    required CreatePurchaseNoteUseCase createPurchaseNoteUseCase,
    required UpdatePurchaseNoteUseCase updatePurchaseNoteUseCase,
  }) : _createPurchaseNoteUseCase = createPurchaseNoteUseCase,
       _updatePurchaseNoteUseCase = updatePurchaseNoteUseCase,
       super(const CreatePurchaseNoteState());

  final CreatePurchaseNoteUseCase _createPurchaseNoteUseCase;
  final UpdatePurchaseNoteUseCase _updatePurchaseNoteUseCase;

  void initializeForEdit(PurchaseNoteDetailEntity data) {
    emit(
      state.copyWith(
        items: data.items,
        note: data.note,
        supplier: DropdownEntity(
          key: data.supplier.id,
          value: data.supplier.name,
        ),
        date: data.date,
        purchaseNoteId: data.id,
      ),
    );
  }

  Future<void> submit() async => state.isEditMode
      ? await updatePurchaseNote()
      : await createPurchaseNote();

  Future<void> createPurchaseNote() async {
    if (state.image == null) {
      const message = 'Silakan pilih gambar nota terlebih dahulu';
      emit(
        state.copyWith(
          status: .failure,
          failure: const Failure(message: message),
        ),
      );
      return emit(state.copyWith(status: .initial));
    }

    if (state.items.isEmpty) {
      const message = 'Silakan tambahkan barang terlebih dahulu';
      emit(
        state.copyWith(
          status: .failure,
          failure: const Failure(message: message),
        ),
      );
      return emit(state.copyWith(status: .initial));
    }

    emit(state.copyWith(status: .inProgress));

    final params = CreatePurchaseNoteUseCaseParams(
      date: state.date!,
      receipt: state.image!.path,
      supplierId: state.supplier!.key,
      items: state.items,
      note: state.note,
    );
    final result = await _createPurchaseNoteUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (message) => emit(state.copyWith(status: .success, message: message)),
    );

    emit(state.copyWith(status: .initial));
  }

  Future<void> updatePurchaseNote() async {
    emit(state.copyWith(status: .inProgress));

    final params = UpdatePurchaseNoteUseCaseParams(
      date: state.date!,
      receipt: state.image!.path,
      supplierId: state.supplier!.key,
      items: state.items,
      purchaseNoteId: state.purchaseNoteId!,
      note: state.note,
    );
    final result = await _updatePurchaseNoteUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (message) => emit(state.copyWith(status: .success, message: message)),
    );

    emit(state.copyWith(status: .initial));
  }

  set supplier(DropdownEntity? supplier) =>
      emit(state.copyWith(supplier: supplier));

  set date(DateTime? date) => emit(state.copyWith(date: date));

  set image(File? image) => emit(state.copyWith(image: image));

  set note(String? note) => emit(state.copyWith(note: note));

  set items(List<WarehouseItemEntity> items) =>
      emit(state.copyWith(items: items));

  void removeItemAt(int index) {
    final updatedItems = [...state.items]..removeAt(index);

    emit(state.copyWith(items: updatedItems));
  }

  void updateItemAt(int index, WarehouseItemEntity editedItem) {
    final updatedItems = [...state.items]..[index] = editedItem;

    emit(state.copyWith(items: updatedItems));
  }
}
