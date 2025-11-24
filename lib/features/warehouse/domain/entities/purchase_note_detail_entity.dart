import '../../../supplier/domain/entities/supplier_entity.dart';
import 'purchase_note_entity.dart';
import 'warehouse_item_entity.dart';

class PurchaseNoteDetailEntity extends PurchaseNoteEntity {
  const PurchaseNoteDetailEntity({
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

  PurchaseNoteDetailEntity copyWith({
    DateTime? date,
    String? receipt,
    String? note,
    String? id,
    bool? isEditable,
    int? returnCost,
    SupplierEntity? supplier,
    int? totalPrice,
    List<WarehouseItemEntity>? items,
  }) {
    return PurchaseNoteDetailEntity(
      date: date ?? this.date,
      receipt: receipt ?? this.receipt,
      note: note ?? this.note,
      id: id ?? this.id,
      isEditable: isEditable ?? this.isEditable,
      returnCost: returnCost ?? this.returnCost,
      supplier: supplier ?? this.supplier,
      totalPrice: totalPrice ?? this.totalPrice,
      items: items ?? this.items,
    );
  }

  final String id;
  final bool isEditable;
  final int returnCost;
  final SupplierEntity supplier;
  final int totalPrice;
  final List<WarehouseItemEntity> items;

  @override
  List<Object?> get props =>
      [...super.props, id, isEditable, returnCost, supplier, totalPrice, items];
}
