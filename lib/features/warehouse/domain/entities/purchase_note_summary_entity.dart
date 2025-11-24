import 'package:equatable/equatable.dart';

import '../../../supplier/domain/entities/supplier_entity.dart';

class PurchaseNoteSummaryEntity extends Equatable {
  const PurchaseNoteSummaryEntity({
    required this.id,
    required this.date,
    required this.supplier,
    required this.totalItems,
  });

  final String id;
  final DateTime date;
  final SupplierEntity supplier;
  final int totalItems;

  @override
  List<Object?> get props => [id, date, supplier, totalItems];
}
