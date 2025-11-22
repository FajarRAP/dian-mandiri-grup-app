class PurchaseNoteEntity {
  const PurchaseNoteEntity({
    required this.date,
    required this.receipt,
    this.note,
  });

  final DateTime date;
  final String receipt;
  final String? note;
}
