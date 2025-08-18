import '../../../supplier/data/models/supplier_model.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import 'warehouse_item_model.dart';

class PurchaseNoteDetailModel extends PurchaseNoteDetailEntity {
  PurchaseNoteDetailModel({
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

  factory PurchaseNoteDetailModel.fromJson(Map<String, dynamic> json) =>
      PurchaseNoteDetailModel(
        date: DateTime.parse(json['date']),
        receipt: json['receipt'],
        note: json['note'],
        id: json['id'],
        isEditable: json['is_editable'],
        returnCost: json['return_cost'],
        supplier: SupplierModel(
          id: json['supplier']['id'],
          avatarUrl: '-',
          name: json['supplier']['name'],
          phoneNumber: '-',
        ),
        totalPrice: json['total_price'],
        items: List<Map<String, dynamic>>.from(json['items'])
            .map(WarehouseItemModel.fromJson)
            .toList(),
      );
}
