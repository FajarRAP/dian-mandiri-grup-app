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
    emit(state.copyWith(status: .inProgress));

    final params = FetchShipmentsUseCaseParams(
      date: date,
      stage: stage,
      search: SearchParams(query: query),
    );
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure)),
      (shipments) =>
          emit(state.copyWith(status: .success, shipments: shipments)),
    );
  }

  Future<void> fetchShipmentsPaginate({
    required DateTime date,
    required String stage,
  }) async {
    if (state.hasReachedMax || state.isPaginating) return;

    emit(state.copyWith(isPaginating: true));

    final params = FetchShipmentsUseCaseParams(
      date: date,
      stage: stage,
      paginate: PaginateParams(page: state.currentPage + 1),
    );
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure)),
      (shipments) => shipments.isEmpty
          ? emit(state.copyWith(hasReachedMax: true, isPaginating: false))
          : emit(
              state.copyWith(
                status: .success,
                shipments: [...state.shipments, ...shipments],
                currentPage: state.currentPage + 1,
                isPaginating: false,
              ),
            ),
    );
  }

  Future<void> createShipment({
    required String receiptNumber,
    required String stage,
  }) async {
    emit(state.copyWith(actionStatus: .inProgress));

    final params = CreateShipmentUseCaseParams(
      receiptNumber: receiptNumber,
      stage: stage,
    );
    final result = await _createShipmentUseCase(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(actionStatus: .failure, failure: failure)),
      (message) =>
          emit(state.copyWith(actionStatus: .success, message: message)),
    );
  }

  Future<void> deleteShipment({required String shipmentId}) async {
    emit(state.copyWith(actionStatus: .inProgress));

    final params = DeleteShipmentUseCaseParams(shipmentId: shipmentId);
    final result = await _deleteShipmentUseCase(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(actionStatus: .failure, failure: failure)),
      (message) =>
          emit(state.copyWith(actionStatus: .success, message: message)),
    );
  }
}
