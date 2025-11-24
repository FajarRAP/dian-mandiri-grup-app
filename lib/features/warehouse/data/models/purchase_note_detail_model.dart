import '../../../../core/utils/typedefs.dart';
import '../../../supplier/data/models/supplier_model.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import 'warehouse_item_model.dart';

class PurchaseNoteDetailModel extends PurchaseNoteDetailEntity {
  const PurchaseNoteDetailModel({
    required super.date,
    required super.receipt,
    required super.note,
    required super.id,
    required super.isEditable,
    required super.returnCost,
    required super.supplier,
    required super.totalPrice,
    required super.items,
  });

  factory PurchaseNoteDetailModel.fromJson(JsonMap json) {
    return PurchaseNoteDetailModel(
      date: DateTime.parse(json['date']),
      receipt: json['receipt'],
      note: json['note'],
      id: json['id'],
      isEditable: json['is_editable'],
      returnCost: json['return_cost'],
      supplier: SupplierModel.fromJson(json['supplier']),
      totalPrice: json['total_price'],
      items: List<JsonMap>.from(json['items'])
          .map(WarehouseItemModel.fromJson)
          .toList(),
    );
  }

  PurchaseNoteDetailEntity toEntity() {
    return PurchaseNoteDetailEntity(
      date: date,
      receipt: receipt,
      note: note,
      id: id,
      isEditable: isEditable,
      returnCost: returnCost,
      supplier: (supplier as SupplierModel).toEntity(),
      totalPrice: totalPrice,
      items: items.map((e) => (e as WarehouseItemModel).toEntity()).toList(),
    );
  }
}
