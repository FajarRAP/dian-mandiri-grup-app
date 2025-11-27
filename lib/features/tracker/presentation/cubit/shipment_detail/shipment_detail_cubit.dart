import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/entities/shipment_detail_entity.dart';
import '../../../domain/entities/shipment_history_entity.dart';
import '../../../domain/usecases/fetch_shipment_status_use_case.dart';
import '../../../domain/usecases/fetch_shipment_use_case.dart';
import '../../../domain/usecases/update_shipment_document_use_case.dart';

part 'shipment_detail_state.dart';

class ShipmentDetailCubit extends Cubit<ShipmentDetailState> {
  ShipmentDetailCubit({
    required FetchShipmentUseCase fetchShipmentUseCase,
    required FetchShipmentStatusUseCase fetchShipmentStatusUseCase,
    required UpdateShipmentDocumentUseCase updateShipmentDocumentUseCase,
  }) : _fetchShipmentUseCase = fetchShipmentUseCase,
       _fetchShipmentStatusUseCase = fetchShipmentStatusUseCase,
       _updateShipmentDocumentUseCase = updateShipmentDocumentUseCase,
       super(ShipmentDetailInitial());

  final FetchShipmentUseCase _fetchShipmentUseCase;
  final FetchShipmentStatusUseCase _fetchShipmentStatusUseCase;
  final UpdateShipmentDocumentUseCase _updateShipmentDocumentUseCase;

  Future<void> fetchShipment({required String shipmentId}) async {
    emit(const FetchShipmentInProgress());

    final params = FetchShipmentUseCaseParams(shipmentId: shipmentId);
    final result = await _fetchShipmentUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentFailure(failure: failure)),
      (shipment) => emit(FetchShipmentSuccess(shipment: shipment)),
    );
  }

  Future<void> updateShipmentDocument({
    required String shipmentId,
    required String stage,
    required String documentPath,
  }) async {
    emit(const ActionInProgress());

    final params = UpdateShipmentDocumentUseCaseParams(
      shipmentId: shipmentId,
      stage: stage,
      documentPath: documentPath,
    );
    final result = await _updateShipmentDocumentUseCase(params);

    result.fold(
      (failure) => emit(ActionFailure(failure: failure)),
      (message) => emit(ActionSuccess(message: message)),
    );
  }

  Future<void> fetchShipmentStatus({required String receiptNumber}) async {
    emit(const FetchShipmentInProgress());

    final params = FetchShipmentStatusUseCaseParams(
      receiptNumber: receiptNumber,
    );
    final result = await _fetchShipmentStatusUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentFailure(failure: failure)),
      (shipment) => emit(FetchShipmentStatusSuccess(shipment: shipment)),
    );
  }
}
