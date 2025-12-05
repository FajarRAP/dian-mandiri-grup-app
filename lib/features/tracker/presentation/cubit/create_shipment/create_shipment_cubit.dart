import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/usecases/create_shipment_use_case.dart';

part 'create_shipment_state.dart';

class CreateShipmentCubit extends Cubit<CreateShipmentState> {
  CreateShipmentCubit({required CreateShipmentUseCase createShipmentUseCase})
    : _createShipmentUseCase = createShipmentUseCase,
      super(const CreateShipmentState());

  final CreateShipmentUseCase _createShipmentUseCase;

  Future<void> createShipment({
    required String receiptNumber,
    required String stage,
  }) async {
    emit(state.copyWith(status: .inProgress));

    final params = CreateShipmentUseCaseParams(
      receiptNumber: receiptNumber,
      stage: stage,
    );
    final result = await _createShipmentUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (message) => emit(state.copyWith(status: .success, message: message)),
    );
  }
}
