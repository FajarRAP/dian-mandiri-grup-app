import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/entities/shipment_entity.dart';
import '../../../domain/usecases/create_shipment_use_case.dart';
import '../../../domain/usecases/delete_shipment_use_case.dart';
import '../../../domain/usecases/fetch_shipments_use_case.dart';

part 'shipment_list_state.dart';

class ShipmentListCubit extends Cubit<ShipmentListState> {
  ShipmentListCubit({
    required FetchShipmentsUseCase fetchShipmentsUseCase,
    required CreateShipmentUseCase insertShipmentUseCase,
    required DeleteShipmentUseCase deleteShipmentUseCase,
  }) : _fetchShipmentsUseCase = fetchShipmentsUseCase,
       _createShipmentUseCase = insertShipmentUseCase,
       _deleteShipmentUseCase = deleteShipmentUseCase,
       super(ShipmentListState.initial());

  final FetchShipmentsUseCase _fetchShipmentsUseCase;
  final CreateShipmentUseCase _createShipmentUseCase;
  final DeleteShipmentUseCase _deleteShipmentUseCase;

  Future<void> fetchShipments({
    required DateTime date,
    required String stage,
    String? query,
  }) async {
    emit(state.copyWith(status: ShipmentListStatus.inProgress));

    final params = FetchShipmentsUseCaseParams(
      date: date,
      stage: stage,
      search: SearchParams(query: query),
    );
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: ShipmentListStatus.failure)),
      (shipments) => emit(
        state.copyWith(
          status: ShipmentListStatus.success,
          shipments: shipments,
        ),
      ),
    );
  }

  Future<void> fetchShipmentsPaginate({
    required DateTime date,
    required String stage,
  }) async {
    final currentState = state;
    if (currentState.hasReachedMax) return;

    emit(currentState.copyWith(isPaginating: true));

    final params = FetchShipmentsUseCaseParams(
      date: date,
      stage: stage,
      paginate: PaginateParams(page: currentState.currentPage + 1),
    );
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: ShipmentListStatus.failure)),
      (shipments) => shipments.isEmpty
          ? emit(
              currentState.copyWith(hasReachedMax: true, isPaginating: false),
            )
          : emit(
              currentState.copyWith(
                shipments: [...currentState.shipments, ...shipments],
                currentPage: currentState.currentPage + 1,
                isPaginating: false,
              ),
            ),
    );
  }

  Future<void> createShipment({
    required String receiptNumber,
    required String stage,
  }) async {
    emit(state.copyWith(actionStatus: ShipmentListActionStatus.inProgress));

    final params = CreateShipmentUseCaseParams(
      receiptNumber: receiptNumber,
      stage: stage,
    );
    final result = await _createShipmentUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: ShipmentListActionStatus.failure,
          failure: failure,
        ),
      ),
      (message) => emit(
        state.copyWith(
          actionStatus: ShipmentListActionStatus.success,
          message: message,
        ),
      ),
    );
  }

  Future<void> deleteShipment({required String shipmentId}) async {
    emit(state.copyWith(actionStatus: ShipmentListActionStatus.inProgress));

    final params = DeleteShipmentUseCaseParams(shipmentId: shipmentId);
    final result = await _deleteShipmentUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: ShipmentListActionStatus.failure,
          failure: failure,
        ),
      ),
      (message) => emit(
        state.copyWith(
          actionStatus: ShipmentListActionStatus.success,
          message: message,
        ),
      ),
    );
  }
}
