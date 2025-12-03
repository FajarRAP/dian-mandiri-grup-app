part of 'purchase_note_cost_cubit.dart';

enum PurchaseNoteCostStatus { initial, inProgress, success, failure }

class PurchaseNoteCostState extends Equatable {
  const PurchaseNoteCostState({
    this.status = .initial,
    this.purchaseNotes = const [],
    this.shippingFee = 0,
    this.updatedReturnCost = 0,
    this.message,
    this.failure,
  });

  // Status
  final PurchaseNoteCostStatus status;

  // State Properties
  final List<DropdownEntity> purchaseNotes;
  final int shippingFee;
  final int updatedReturnCost;

  // Success
  final String? message;

  // Failure
  final Failure? failure;

  PurchaseNoteCostState copyWith({
    PurchaseNoteCostStatus? status,
    List<DropdownEntity>? purchaseNotes,
    int? shippingFee,
    int? updatedReturnCost,
    String? message,
    Failure? failure,
  }) {
    return PurchaseNoteCostState(
      status: status ?? this.status,
      purchaseNotes: purchaseNotes ?? this.purchaseNotes,
      shippingFee: shippingFee ?? this.shippingFee,
      updatedReturnCost: updatedReturnCost ?? this.updatedReturnCost,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    purchaseNotes,
    shippingFee,
    updatedReturnCost,
    message,
    failure,
  ];
}
