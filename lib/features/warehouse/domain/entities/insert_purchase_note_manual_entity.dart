import 'purchase_note_entity.dart';
import 'warehouse_item_entity.dart';

class InsertPurchaseNoteManualEntity extends PurchaseNoteEntity {
  const InsertPurchaseNoteManualEntity({
    required super.date,
    required super.receipt,
    super.note,
    required this.supplierId,
    required this.items,
  });

  final String supplierId;
  final List<WarehouseItemEntity> items;
}
