import '../../../supplier/domain/entities/supplier_entity.dart';

class PurchaseNoteSummaryEntity {
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
}
