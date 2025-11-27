part of 'shipment_detail_cubit.dart';

sealed class ShipmentDetailState extends Equatable {
  const ShipmentDetailState();

  @override
  List<Object> get props => [];
}

final class ShipmentDetailInitial extends ShipmentDetailState {}

class FetchShipmentInProgress extends ShipmentDetailState {
  const FetchShipmentInProgress();
}

class FetchShipmentSuccess extends ShipmentDetailState {
  const FetchShipmentSuccess({required this.shipment});

  final ShipmentDetailEntity shipment;

  @override
  List<Object> get props => [shipment];
}

class FetchShipmentStatusSuccess extends ShipmentDetailState {
  const FetchShipmentStatusSuccess({required this.shipment});

  final ShipmentHistoryEntity shipment;

  @override
  List<Object> get props => [shipment];
}

class FetchShipmentFailure extends ShipmentDetailState {
  const FetchShipmentFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}

class ActionInProgress extends ShipmentDetailState {
  const ActionInProgress();
}

class ActionSuccess extends ShipmentDetailState {
  const ActionSuccess({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class ActionFailure extends ShipmentDetailState {
  const ActionFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
