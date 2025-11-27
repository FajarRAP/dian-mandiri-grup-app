part of 'shipment_report_cubit.dart';

enum ShipmentReportStatus { initial, inProgress, success, failure }

enum ShipmentReportActionStatus { initial, inProgress, success, failure }

class ShipmentReportState extends Equatable {
  const ShipmentReportState({
    required this.status,
    required this.actionStatus,
    required this.reports,
    required this.currentPage,
    required this.hasReachedMax,
    required this.isPaginating,
    this.message,
    this.failure,
  });

  factory ShipmentReportState.initial() {
    return const ShipmentReportState(
      status: ShipmentReportStatus.initial,
      actionStatus: ShipmentReportActionStatus.initial,
      reports: [],
      currentPage: 1,
      hasReachedMax: false,
      isPaginating: false,
      message: null,
      failure: null,
    );
  }

  final ShipmentReportStatus status;
  final ShipmentReportActionStatus actionStatus;

  final List<ShipmentReportEntity> reports;
  final int currentPage;
  final bool hasReachedMax;
  final bool isPaginating;

  final String? message;
  final Failure? failure;

  ShipmentReportState copyWith({
    ShipmentReportStatus? status,
    ShipmentReportActionStatus? actionStatus,
    List<ShipmentReportEntity>? reports,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
    String? message,
    Failure? failure,
  }) {
    return ShipmentReportState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      reports: reports ?? this.reports,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    actionStatus,
    reports,
    currentPage,
    hasReachedMax,
    isPaginating,
    message,
    failure,
  ];
}
