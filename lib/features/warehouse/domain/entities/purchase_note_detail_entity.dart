import '../../../supplier/domain/entities/supplier_entity.dart';
import 'purchase_note_entity.dart';
import 'warehouse_item_entity.dart';

class PurchaseNoteDetailEntity extends PurchaseNoteEntity {
  PurchaseNoteDetailEntity({
    required super.date,
    required super.receipt,
    required super.note,
    required this.id,
    required this.isEditable,
    required this.returnCost,
    required this.supplier,
    required this.totalPrice,
    required this.items,
  });

  final String id;
  final bool isEditable;
  int returnCost;
  final SupplierEntity supplier;
  int totalPrice;
  final List<WarehouseItemEntity> items;
}
