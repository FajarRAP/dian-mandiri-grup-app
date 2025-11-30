part of 'supplier_detail_cubit.dart';

enum SupplierDetailStatus { initial, inProgress, success, failure }

class SupplierDetailState extends Equatable {
  const SupplierDetailState({
    this.status = .initial,
    this.supplier,
    this.failure,
  });

  final SupplierDetailStatus status;
  final SupplierDetailEntity? supplier;

  final Failure? failure;

  SupplierDetailState copyWith({
    SupplierDetailStatus? status,
    SupplierDetailEntity? supplier,
    Failure? failure,
  }) {
    return SupplierDetailState(
      status: status ?? this.status,
      supplier: supplier ?? this.supplier,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, supplier, failure];
}
