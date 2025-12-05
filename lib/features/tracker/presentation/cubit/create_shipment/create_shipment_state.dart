part of 'create_shipment_cubit.dart';

enum CreateShipmentStatus { initial, inProgress, success, failure }

class CreateShipmentState extends Equatable {
  const CreateShipmentState({
    this.status = .initial,
    this.message,
    this.failure,
  });

  // Status
  final CreateShipmentStatus status;

  // Success
  final String? message;

  // Failure
  final Failure? failure;

  CreateShipmentState copyWith({
    CreateShipmentStatus? status,
    String? message,
    Failure? failure,
  }) {
    return CreateShipmentState(
      status: status ?? this.status,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, message, failure];
}
