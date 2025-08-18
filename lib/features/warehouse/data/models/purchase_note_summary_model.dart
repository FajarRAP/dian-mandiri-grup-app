import '../../../supplier/data/models/supplier_model.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';

class PurchaseNoteSummaryModel extends PurchaseNoteSummaryEntity {
  const PurchaseNoteSummaryModel({
    required super.id,
    required super.date,
    required super.supplier,
    required super.totalItems,
  });

  factory PurchaseNoteSummaryModel.fromJson(Map<String, dynamic> json) =>
      PurchaseNoteSummaryModel(
        id: json['id'],
        date: DateTime.parse(json['date']),
        supplier: SupplierModel(
          avatarUrl: '-',
          id: '-',
          name: json['supplier'],
          phoneNumber: '-',
        ),
        totalItems: json['total'],
      );
}
