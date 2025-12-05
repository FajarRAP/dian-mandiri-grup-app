part of 'create_supplier_cubit.dart';

enum CreateSupplierStatus { initial, inProgress, success, failure }

class CreateSupplierState extends Equatable {
  const CreateSupplierState({
    this.status = .initial,
    this.message,
    this.failure,
  });

  final CreateSupplierStatus status;
  final String? message;

  final Failure? failure;

  CreateSupplierState copyWith({
    CreateSupplierStatus? status,
    String? message,
    Failure? failure,
  }) {
    return CreateSupplierState(
      status: status ?? this.status,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, message, failure];
}
