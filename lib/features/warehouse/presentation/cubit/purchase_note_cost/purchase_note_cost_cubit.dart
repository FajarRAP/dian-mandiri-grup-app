import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/usecases/update_return_cost_use_case.dart';

part 'purchase_note_cost_state.dart';

class PurchaseNoteCostCubit extends Cubit<PurchaseNoteCostState> {
  PurchaseNoteCostCubit({
    required UpdateReturnCostUseCase updateReturnCostUseCase,
  }) : _updateReturnCostUseCase = updateReturnCostUseCase,
       super(const PurchaseNoteCostState());

  final UpdateReturnCostUseCase _updateReturnCostUseCase;

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

  set updatedReturnCost(int? returnCost) =>
      emit(state.copyWith(updatedReturnCost: returnCost));
}
