import '../../domain/entities/insert_purchase_note_file_entity.dart';

class InsertPurchaseNoteFileModel extends InsertPurchaseNoteFileEntity {
  InsertPurchaseNoteFileModel({
    required super.date,
    required super.receipt,
    required super.note,
    required super.supplierId,
    required super.file,
  });

  factory InsertPurchaseNoteFileModel.fromEntity(
          InsertPurchaseNoteFileEntity entity) =>
      InsertPurchaseNoteFileModel(
        date: entity.date,
        receipt: entity.receipt,
        note: entity.note,
        supplierId: entity.supplierId,
        file: entity.file,
      );

  Map<String, dynamic> toJson() => {
        'supplier_id': supplierId,
        'date': date.toIso8601String(),
        'note': note,
      };
}
