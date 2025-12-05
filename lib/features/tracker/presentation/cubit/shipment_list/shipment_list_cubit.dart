import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/entities/shipment_entity.dart';
import '../../../domain/usecases/delete_shipment_use_case.dart';
import '../../../domain/usecases/fetch_shipments_use_case.dart';

part 'shipment_list_state.dart';

class ShipmentListCubit extends Cubit<ShipmentListState> {
  ShipmentListCubit({
    required FetchShipmentsUseCase fetchShipmentsUseCase,
    required DeleteShipmentUseCase deleteShipmentUseCase,
  }) : _fetchShipmentsUseCase = fetchShipmentsUseCase,
       _deleteShipmentUseCase = deleteShipmentUseCase,
       super(const ShipmentListState());

  final FetchShipmentsUseCase _fetchShipmentsUseCase;
  final DeleteShipmentUseCase _deleteShipmentUseCase;

  Future<void> fetchShipments({
    DateTime? date,
    String? stage,
    String? query,
  }) async {
    final effectiveQuery = query ?? state.query;
    final effectiveDate = date ?? state.date ?? DateTime.now();

    emit(
      state.copyWith(
        status: .inProgress,
        query: effectiveQuery,
        date: effectiveDate,
        stage: stage,
        currentPage: 1,
        hasReachedMax: false,
        isPaginating: false,
      ),
    );

    final params = FetchShipmentsUseCaseParams(
      date: effectiveDate,
      stage: state.stage!,
      search: SearchParams(query: effectiveQuery),
    );
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (shipments) => emit(
        state.copyWith(
          status: .success,
          shipments: shipments,
          hasReachedMax: shipments.isEmpty,
        ),
      ),
    );
  }

  Future<void> fetchShipmentsPaginate() async {
    if (state.hasReachedMax || state.isPaginating) return;

    emit(state.copyWith(isPaginating: true));

    final params = FetchShipmentsUseCaseParams(
      date: state.date!,
      stage: state.stage!,
      search: SearchParams(query: state.query),
      paginate: PaginateParams(page: state.currentPage + 1),
    );
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: .failure,
          hasReachedMax: true,
          isPaginating: false,
          failure: failure,
        ),
      ),
      (shipments) => emit(
        state.copyWith(
          status: .success,
          isPaginating: false,
          hasReachedMax: shipments.isEmpty,
          currentPage: state.currentPage + 1,
          shipments: [...state.shipments, ...shipments],
        ),
      ),
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

  set date(DateTime? date) => emit(state.copyWith(date: date));
}
