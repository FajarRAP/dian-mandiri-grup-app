import '../../domain/entities/insert_purchase_note_manual_entity.dart';
import 'warehouse_item_model.dart';

class InsertPurchaseNoteManualModel extends InsertPurchaseNoteManualEntity {
  const InsertPurchaseNoteManualModel({
    required super.date,
    required super.receipt,
    super.note,
    required super.supplierId,
    required super.items,
  });

  factory InsertPurchaseNoteManualModel.fromEntity(
          InsertPurchaseNoteManualEntity entity) =>
      InsertPurchaseNoteManualModel(
        date: entity.date,
        receipt: entity.receipt,
        note: entity.note,
        supplierId: entity.supplierId,
        items: entity.items,
      );

  Map<String, dynamic> toJson() => {
        'supplier_id': supplierId,
        'date': date.toUtc().toIso8601String(),
        'note': note,
        'items': items
            .map((item) => WarehouseItemModel.fromEntity(item).toJson())
            .toList(),
      };
}
