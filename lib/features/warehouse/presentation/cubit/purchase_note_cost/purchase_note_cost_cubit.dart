import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/domain/entities/dropdown_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/usecases/add_shipping_fee_use_case.dart';
import '../../../domain/usecases/update_return_cost_use_case.dart';

part 'purchase_note_cost_state.dart';

class PurchaseNoteCostCubit extends Cubit<PurchaseNoteCostState> {
  PurchaseNoteCostCubit({
    required UpdateReturnCostUseCase updateReturnCostUseCase,
    required AddShippingFeeUseCase addShippingFeeUseCase,
  }) : _updateReturnCostUseCase = updateReturnCostUseCase,
       _addShippingFeeUseCase = addShippingFeeUseCase,
       super(const PurchaseNoteCostState());

  final UpdateReturnCostUseCase _updateReturnCostUseCase;
  final AddShippingFeeUseCase _addShippingFeeUseCase;

  Future<void> updateReturnCost({
    required String purchaseNoteId,
    required int returnCost,
  }) async {
    emit(state.copyWith(status: .inProgress));

    final params = UpdateReturnCostUseCaseParams(
      purchaseNoteId: purchaseNoteId,
      amount: returnCost,
    );
    final result = await _updateReturnCostUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (message) => emit(state.copyWith(status: .success, message: message)),
    );
  }

  Future<void> addShippingFee() async {
    if (state.purchaseNotes.isEmpty) {
      const message = 'Pilih minimal 1 nota';
      return emit(
        state.copyWith(
          status: .failure,
          failure: const Failure(message: message),
        ),
      );
    }

    emit(state.copyWith(status: .inProgress));

    final params = AddShippingFeeUseCaseParams(
      purchaseNoteIds: state.purchaseNotes.map((e) => e.key).toList(),
      price: state.shippingFee,
    );
    final result = await _addShippingFeeUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (message) => emit(state.copyWith(status: .success, message: message)),
    );

    emit(state.copyWith(status: .initial));
  }

  set updatedReturnCost(int? returnCost) =>
      emit(state.copyWith(updatedReturnCost: returnCost));

  set shippingFee(int? shippingFee) =>
      emit(state.copyWith(shippingFee: shippingFee));

  void addPurchaseNote(DropdownEntity purchaseNote) {
    if (state.purchaseNotes.contains(purchaseNote)) {
      return emit(
        state.copyWith(
          status: .failure,
          failure: const Failure(message: 'Nota sudah ditambahkan'),
        ),
      );
    }

    emit(
      state.copyWith(
        status: .initial,
        purchaseNotes: [...state.purchaseNotes, purchaseNote],
      ),
    );
  }

  void removePurchaseNoteAt(int index) {
    final updatedPurchaseNotes = [...state.purchaseNotes]..removeAt(index);

    emit(state.copyWith(status: .initial, purchaseNotes: updatedPurchaseNotes));
  }
}
