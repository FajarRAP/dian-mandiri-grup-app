import 'package:equatable/equatable.dart';

class PurchaseNoteEntity extends Equatable {
  const PurchaseNoteEntity({
    required this.date,
    required this.receipt,
    this.note,
  });

  final DateTime date;
  final String receipt;
  final String? note;

  @override
  List<Object?> get props => [date, receipt, note];
}
