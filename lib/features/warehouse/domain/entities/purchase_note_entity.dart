class PurchaseNoteEntity {
  final DateTime date;
  final String receipt;
  final String? note;

  const PurchaseNoteEntity({
    required this.date,
    required this.receipt,
    this.note,
  });
}
