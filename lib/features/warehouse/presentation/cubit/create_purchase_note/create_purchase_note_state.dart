part of 'create_purchase_note_cubit.dart';

enum CreatePurchaseNoteStatus { initial, inProgress, success, failure }

class CreatePurchaseNoteState extends Equatable {
  const CreatePurchaseNoteState({
    this.status = .initial,
    this.purchaseNoteId,
    this.items = const [],
    this.note,
    this.date,
    this.supplier,
    this.image,
    this.message,
    this.failure,
  });

  // Status
  final CreatePurchaseNoteStatus status;

  // State Properties
  final String? purchaseNoteId;
  final List<WarehouseItemEntity> items;
  final String? note;
  final DateTime? date;
  final DropdownEntity? supplier;
  final File? image;

  // Success
  final String? message;

  // Failure
  final Failure? failure;

  double get totalAmount =>
      items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  bool get isEditMode => purchaseNoteId != null;

  CreatePurchaseNoteState copyWith({
    CreatePurchaseNoteStatus? status,
    String? purchaseNoteId,
    List<WarehouseItemEntity>? items,
    String? note,
    DateTime? date,
    DropdownEntity? supplier,
    File? image,
    String? message,
    Failure? failure,
  }) {
    return CreatePurchaseNoteState(
      status: status ?? this.status,
      purchaseNoteId: purchaseNoteId ?? this.purchaseNoteId,
      items: items ?? this.items,
      note: note ?? this.note,
      date: date ?? this.date,
      supplier: supplier ?? this.supplier,
      image: image ?? this.image,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    purchaseNoteId,
    items,
    note,
    date,
    supplier,
    image,
    message,
    failure,
  ];
}
