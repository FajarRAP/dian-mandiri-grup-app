import '../../domain/entities/insert_purchase_note_manual_entity.dart';
import 'warehouse_item_model.dart';

class InsertPurchaseNoteManualModel extends InsertPurchaseNoteManualEntity {
  const InsertPurchaseNoteManualModel({
    required super.date,
    required super.receipt,
    required super.note,
    required super.supplierId,
    required super.items,
  });

  factory InsertPurchaseNoteManualModel.fromEntity(
      InsertPurchaseNoteManualEntity entity) {
    return InsertPurchaseNoteManualModel(
      date: entity.date,
      receipt: entity.receipt,
      note: entity.note,
      supplierId: entity.supplierId,
      items: entity.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplier_id': supplierId,
      'date': date,
      'note': note,
      'items': items
          .map((item) => WarehouseItemModel.fromEntity(item).toJson())
          .toList(),
    };
  }
}
