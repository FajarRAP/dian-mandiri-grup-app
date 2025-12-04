part of 'create_shipment_report_cubit.dart';

enum CreateShipmentReportStatus { initial, inProgress, success, failure }

class CreateShipmentReportState extends Equatable {
  const CreateShipmentReportState({
    this.status = .initial,
    this.dateTimeRange,
    this.message,
    this.failure,
  });

  // Status
  final CreateShipmentReportStatus status;

  // State Properties
  final DateTimeRange? dateTimeRange;

  // Success
  final String? message;

  // Failure
  final Failure? failure;

  CreateShipmentReportState copyWith({
    CreateShipmentReportStatus? status,
    DateTimeRange? dateTimeRange,
    String? message,
    Failure? failure,
  }) {
    return CreateShipmentReportState(
      status: status ?? this.status,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, dateTimeRange, message, failure];
}
