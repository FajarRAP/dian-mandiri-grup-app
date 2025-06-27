import 'purchase_note_entity.dart';

class InsertPurchaseNoteFileEntity extends PurchaseNoteEntity {
  const InsertPurchaseNoteFileEntity({
    required super.date,
    required super.receipt,
    required super.note,
    required this.supplierId,
    required this.file,
  });

  final String supplierId;
  final String file;
}
