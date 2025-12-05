import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/entities/purchase_note_detail_entity.dart';
import '../../../domain/usecases/fetch_purchase_note_use_case.dart';

part 'purchase_note_detail_state.dart';

class PurchaseNoteDetailCubit extends Cubit<PurchaseNoteDetailState> {
  PurchaseNoteDetailCubit({
    required FetchPurchaseNoteUseCase fetchPurchaseNoteUseCase,
  }) : _fetchPurchaseNoteUseCase = fetchPurchaseNoteUseCase,
       super(const PurchaseNoteDetailState());

  final FetchPurchaseNoteUseCase _fetchPurchaseNoteUseCase;

  Future<void> fetchPurchaseNote({required String purchaseNoteId}) async {
    emit(state.copyWith(status: .inProgress));

    final params = FetchPurchaseNoteUseCaseParams(
      purchaseNoteId: purchaseNoteId,
    );
    final result = await _fetchPurchaseNoteUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (purchaseNote) =>
          emit(state.copyWith(status: .success, purchaseNote: purchaseNote)),
    );
  }
}
