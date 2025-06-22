part of 'supplier_cubit.dart';

@immutable
sealed class SupplierState {}

final class SupplierInitial extends SupplierState {}

class FetchSupplier extends SupplierState {}

class FetchSupplierLoading extends FetchSupplier {}

class FetchSupplierLoaded extends FetchSupplier {
  final SupplierDetailEntity supplierDetail;

  FetchSupplierLoaded({required this.supplierDetail});
}

class FetchSupplierError extends FetchSupplier {
  final String message;

  FetchSupplierError({required this.message});
}

class FetchSuppliers extends SupplierState {}

class FetchSuppliersLoading extends FetchSuppliers {}

class FetchSuppliersLoaded extends FetchSuppliers {
  final List<SupplierEntity> suppliers;

  FetchSuppliersLoaded({required this.suppliers});
}

class FetchSuppliersError extends FetchSuppliers {
  final String message;

  FetchSuppliersError({required this.message});
}

class FetchSuppliersDropdown extends SupplierState {}

class FetchSuppliersDropdownLoading extends FetchSuppliersDropdown {}

class FetchSuppliersDropdownLoaded extends FetchSuppliersDropdown {
  final List<DropdownEntity> suppliers;

  FetchSuppliersDropdownLoaded({required this.suppliers});
}

class FetchSuppliersDropdownError extends FetchSuppliersDropdown {
  final String message;

  FetchSuppliersDropdownError({required this.message});
}

class InsertSupplier extends SupplierState {}

class InsertSupplierLoading extends InsertSupplier {}

class InsertSupplierLoaded extends InsertSupplier {
  final SupplierDetailEntity supplierDetail;

  InsertSupplierLoaded({required this.supplierDetail});
}

class InsertSupplierError extends InsertSupplier {
  final String message;

  InsertSupplierError({required this.message});
}

class UpdateSupplier extends SupplierState {}

class UpdateSupplierLoading extends UpdateSupplier {}

class UpdateSupplierLoaded extends UpdateSupplier {
  final SupplierDetailEntity supplierDetail;

  UpdateSupplierLoaded({required this.supplierDetail});
}

class UpdateSupplierError extends UpdateSupplier {
  final String message;

  UpdateSupplierError({required this.message});
}
