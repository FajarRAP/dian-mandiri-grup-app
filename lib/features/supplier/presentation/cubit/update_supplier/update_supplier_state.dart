part of 'update_supplier_cubit.dart';

enum UpdateSupplierStatus { initial, inProgress, success, failure }

class UpdateSupplierState extends Equatable {
  const UpdateSupplierState({
    this.status = .initial,
    this.message,
    this.failure,
  });

  final UpdateSupplierStatus status;
  final String? message;

  final Failure? failure;

  UpdateSupplierState copyWith({
    UpdateSupplierStatus? status,
    String? message,
    Failure? failure,
  }) {
    return UpdateSupplierState(
      status: status ?? this.status,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, message, failure];
}
