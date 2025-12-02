part of 'purchase_note_form_cubit.dart';

enum PurchaseNoteFormStatus { initial, inProgress, success, failure }

class PurchaseNoteFormState extends Equatable {
  const PurchaseNoteFormState({
    this.status = .initial,
    this.items = const [],
    this.returnCost = 0,
    this.note,
    this.date,
    this.supplier,
    this.image,
    this.purchaseNoteId,
    this.receiptUrl,
    this.message,
    this.failure,
  });

  // Status
  final PurchaseNoteFormStatus status;

  // Shared State Properties
  final List<WarehouseItemEntity> items;
  final int returnCost;
  final String? note;
  final DateTime? date;
  final DropdownEntity? supplier;
  final File? image;

  // Edit Properties
  final String? purchaseNoteId;
  final String? receiptUrl;

  // Success
  final String? message;

  // Failure
  final Failure? failure;

  double get totalAmount =>
      items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  bool get isEditMode => purchaseNoteId != null;

  PurchaseNoteFormState copyWith({
    PurchaseNoteFormStatus? status,
    List<WarehouseItemEntity>? items,
    int? returnCost,
    String? note,
    DateTime? date,
    DropdownEntity? supplier,
    File? image,
    String? purchaseNoteId,
    String? receiptUrl,
    String? message,
    Failure? failure,
  }) {
    return PurchaseNoteFormState(
      status: status ?? this.status,
      items: items ?? this.items,
      returnCost: returnCost ?? this.returnCost,
      note: note ?? this.note,
      date: date ?? this.date,
      supplier: supplier ?? this.supplier,
      image: image ?? this.image,
      purchaseNoteId: purchaseNoteId ?? this.purchaseNoteId,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    returnCost,
    note,
    date,
    supplier,
    image,
    purchaseNoteId,
    receiptUrl,
    message,
    failure,
  ];
}
