part of 'purchase_note_cost_cubit.dart';

enum PurchaseNoteCostStatus { initial, inProgress, success, failure }

class PurchaseNoteCostState extends Equatable {
  const PurchaseNoteCostState({
    this.status = .initial,
    this.updatedReturnCost = 0,
    this.message,
    this.failure,
  });

  // Status
  final PurchaseNoteCostStatus status;

  // State Properties
  final int updatedReturnCost;

  // Success
  final String? message;

  // Failure
  final Failure? failure;

  PurchaseNoteCostState copyWith({
    PurchaseNoteCostStatus? status,
    int? updatedReturnCost,
    String? message,
    Failure? failure,
  }) {
    return PurchaseNoteCostState(
      status: status ?? this.status,
      updatedReturnCost: updatedReturnCost ?? this.updatedReturnCost,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, updatedReturnCost, message, failure];
}
