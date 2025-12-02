part of 'purchase_note_detail_cubit.dart';

enum PurchaseNoteDetailStatus { initial, inProgress, success, failure }

class PurchaseNoteDetailState extends Equatable {
  const PurchaseNoteDetailState({
    this.status = .initial,
    this.purchaseNote,
    this.failure,
  });

  // Status
  final PurchaseNoteDetailStatus status;

  // State Properties
  final PurchaseNoteDetailEntity? purchaseNote;

  // Failure
  final Failure? failure;

  PurchaseNoteDetailState copyWith({
    PurchaseNoteDetailStatus? status,
    PurchaseNoteDetailEntity? purchaseNote,
    Failure? failure,
  }) {
    return PurchaseNoteDetailState(
      status: status ?? this.status,
      purchaseNote: purchaseNote ?? this.purchaseNote,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, purchaseNote, failure];
}