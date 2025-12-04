part of 'shipment_list_cubit.dart';

enum ShipmentListStatus { initial, inProgress, success, failure }

enum ShipmentListActionStatus { initial, inProgress, success, failure }

class ShipmentListState extends Equatable {
  const ShipmentListState({
    this.status = .initial,
    this.actionStatus = .initial,
    this.shipments = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isPaginating = false,
    this.stage,
    this.query,
    this.date,
    this.message,
    this.failure,
  });

  // Status
  final ShipmentListStatus status;
  final ShipmentListActionStatus actionStatus;

  // States Properties
  final List<ShipmentEntity> shipments;
  final int currentPage;
  final bool hasReachedMax;
  final bool isPaginating;
  // Filters
  final String? stage;
  final String? query;
  final DateTime? date;

  // Success
  final String? message;

  // Failure
  final Failure? failure;

  ShipmentListState copyWith({
    ShipmentListStatus? status,
    ShipmentListActionStatus? actionStatus,
    List<ShipmentEntity>? shipments,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
    String? stage,
    String? query,
    DateTime? date,
    String? message,
    Failure? failure,
  }) {
    return ShipmentListState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      shipments: shipments ?? this.shipments,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
      stage: stage ?? this.stage,
      query: query ?? this.query,
      date: date ?? this.date,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    actionStatus,
    shipments,
    hasReachedMax,
    currentPage,
    isPaginating,
    stage,
    query,
    date,
    message,
    failure,
  ];
}
