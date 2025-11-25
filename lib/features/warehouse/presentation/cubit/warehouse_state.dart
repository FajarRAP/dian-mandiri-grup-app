part of 'warehouse_cubit.dart';

@immutable
sealed class WarehouseState extends Equatable {
  const WarehouseState();

  @override
  List<Object?> get props => [];
}
// class WarehouseState extends Equatable {
//   const WarehouseState({
//     required this.deletePurchaseNote,
//     required this.fetchPurchaseNote,
//     required this.fetchPurchaseNotesDropdown,
//     required this.fetchPurchaseNotes,
//     required this.insertPurchaseNoteFile,
//     required this.insertPurchaseNoteManual,
//     required this.insertReturnCost,
//     required this.insertShippingFee,
//     required this.updatePurchaseNote,
//   });

//   factory WarehouseState.initial() {
//     return WarehouseState(
//       deletePurchaseNote: ActionInitial<String>(),
//       fetchPurchaseNote: ActionInitial<PurchaseNoteDetailEntity>(),
//       fetchPurchaseNotesDropdown: PaginateInitial<DropdownEntity>(),
//       fetchPurchaseNotes: PaginateInitial<PurchaseNoteSummaryEntity>(),
//       insertPurchaseNoteFile: ActionInitial<String>(),
//       insertPurchaseNoteManual: ActionInitial<String>(),
//       insertReturnCost: ActionInitial<String>(),
//       insertShippingFee: ActionInitial<String>(),
//       updatePurchaseNote: ActionInitial<String>(),
//     );
//   }

//   WarehouseState copyWith({
//     ActionState<String>? deletePurchaseNote,
//     ActionState<PurchaseNoteDetailEntity>? fetchPurchaseNote,
//     PaginateState<DropdownEntity>? fetchPurchaseNotesDropdown,
//     PaginateState<PurchaseNoteSummaryEntity>? fetchPurchaseNotes,
//     ActionState<String>? insertPurchaseNoteFile,
//     ActionState<String>? insertPurchaseNoteManual,
//     ActionState<String>? insertReturnCost,
//     ActionState<String>? insertShippingFee,
//     ActionState<String>? updatePurchaseNote,
//   }) {
//     return WarehouseState(
//       deletePurchaseNote: deletePurchaseNote ?? this.deletePurchaseNote,
//       fetchPurchaseNote: fetchPurchaseNote ?? this.fetchPurchaseNote,
//       fetchPurchaseNotesDropdown:
//           fetchPurchaseNotesDropdown ?? this.fetchPurchaseNotesDropdown,
//       fetchPurchaseNotes: fetchPurchaseNotes ?? this.fetchPurchaseNotes,
//       insertPurchaseNoteFile:
//           insertPurchaseNoteFile ?? this.insertPurchaseNoteFile,
//       insertPurchaseNoteManual:
//           insertPurchaseNoteManual ?? this.insertPurchaseNoteManual,
//       insertReturnCost: insertReturnCost ?? this.insertReturnCost,
//       insertShippingFee: insertShippingFee ?? this.insertShippingFee,
//       updatePurchaseNote: updatePurchaseNote ?? this.updatePurchaseNote,
//     );
//   }

//   final ActionState<String> deletePurchaseNote;
//   final ActionState<PurchaseNoteDetailEntity> fetchPurchaseNote;
//   final PaginateState<DropdownEntity> fetchPurchaseNotesDropdown;
//   final PaginateState<PurchaseNoteSummaryEntity> fetchPurchaseNotes;
//   final ActionState<String> insertPurchaseNoteFile;
//   final ActionState<String> insertPurchaseNoteManual;
//   final ActionState<String> insertReturnCost;
//   final ActionState<String> insertShippingFee;
//   final ActionState<String> updatePurchaseNote;

//   @override
//   List<Object?> get props => [
//         deletePurchaseNote,
//         fetchPurchaseNote,
//         fetchPurchaseNotesDropdown,
//         fetchPurchaseNote,
//         insertPurchaseNoteFile,
//         insertPurchaseNoteManual,
//         insertReturnCost,
//         insertShippingFee,
//         updatePurchaseNote,
//       ];
// }

final class WarehouseInitial extends WarehouseState {}

class ListPaginate extends WarehouseState {}

class ListPaginateLoading extends ListPaginate {}

class ListPaginateLoaded extends ListPaginate {}

class ListPaginateLast extends ListPaginate {
  ListPaginateLast(this.page);

  final int page;
}

class DeletePurchaseNote extends WarehouseState {}

class DeletePurchaseNoteLoading extends DeletePurchaseNote {}

class DeletePurchaseNoteLoaded extends DeletePurchaseNote {
  final String message;

  DeletePurchaseNoteLoaded({required this.message});
}

class DeletePurchaseNoteError extends DeletePurchaseNote {
  final String message;

  DeletePurchaseNoteError({required this.message});
}

class FetchPurchaseNote extends WarehouseState {
  const FetchPurchaseNote();
}

class FetchPurchaseNoteLoading extends FetchPurchaseNote {}

class FetchPurchaseNoteLoaded extends FetchPurchaseNote {
  const FetchPurchaseNoteLoaded({required this.purchaseNote, this.pickedImage});

  FetchPurchaseNoteLoaded copyWith({
    PurchaseNoteDetailEntity? purchaseNote,
    File? pickedImage,
  }) {
    return FetchPurchaseNoteLoaded(
      purchaseNote: purchaseNote ?? this.purchaseNote,
      pickedImage: pickedImage ?? this.pickedImage,
    );
  }

  final PurchaseNoteDetailEntity purchaseNote;
  final File? pickedImage;

  @override
  List<Object?> get props => [purchaseNote, pickedImage];
}

class FetchPurchaseNoteError extends FetchPurchaseNote {
  const FetchPurchaseNoteError({required this.message});

  final String message;
}

class FetchPurchaseNotes extends WarehouseState {}

class FetchPurchaseNotesLoading extends FetchPurchaseNotes {}

class FetchPurchaseNotesLoaded extends FetchPurchaseNotes {
  final List<PurchaseNoteSummaryEntity> purchaseNotes;

  FetchPurchaseNotesLoaded({required this.purchaseNotes});
}

class FetchPurchaseNotesError extends FetchPurchaseNotes {
  final String message;

  FetchPurchaseNotesError({required this.message});
}

class FetchPurchaseNotesDropdown extends WarehouseState {}

class FetchPurchaseNotesDropdownLoading extends FetchPurchaseNotesDropdown {}

class FetchPurchaseNotesDropdownLoaded extends FetchPurchaseNotesDropdown {
  final List<DropdownEntity> purchaseNotes;

  FetchPurchaseNotesDropdownLoaded({required this.purchaseNotes});
}

class FetchPurchaseNotesDropdownError extends FetchPurchaseNotesDropdown {
  final String message;

  FetchPurchaseNotesDropdownError({required this.message});
}

class InsertPurchaseNoteManual extends WarehouseState {}

class InsertPurchaseNoteManualLoading extends InsertPurchaseNoteManual {}

class InsertPurchaseNoteManualLoaded extends InsertPurchaseNoteManual {
  final String message;

  InsertPurchaseNoteManualLoaded({required this.message});
}

class InsertPurchaseNoteManualError extends InsertPurchaseNoteManual {
  final String message;

  InsertPurchaseNoteManualError({required this.message});
}

class InsertPurchaseNoteFile extends WarehouseState {}

class InsertPurchaseNoteFileLoading extends InsertPurchaseNoteFile {}

class InsertPurchaseNoteFileLoaded extends InsertPurchaseNoteFile {
  final String message;

  InsertPurchaseNoteFileLoaded({required this.message});
}

class InsertPurchaseNoteFileError extends InsertPurchaseNoteFile {
  final Failure failure;

  InsertPurchaseNoteFileError({required this.failure});
}

class InsertShippingFee extends WarehouseState {}

class InsertShippingFeeLoading extends InsertShippingFee {}

class InsertShippingFeeLoaded extends InsertShippingFee {
  final String message;

  InsertShippingFeeLoaded({required this.message});
}

class InsertShippingFeeError extends InsertShippingFee {
  final String message;

  InsertShippingFeeError({required this.message});
}

class UpdatePurchaseNote extends WarehouseState {}

class UpdatePurchaseNoteLoading extends UpdatePurchaseNote {}

class UpdatePurchaseNoteLoaded extends UpdatePurchaseNote {
  final String message;

  UpdatePurchaseNoteLoaded({required this.message});
}

class UpdatePurchaseNoteError extends UpdatePurchaseNote {
  final String message;

  UpdatePurchaseNoteError({required this.message});
}

class InsertReturnCost extends WarehouseState {}

class InsertReturnCostLoading extends InsertReturnCost {}

class InsertReturnCostLoaded extends InsertReturnCost {
  final String message;

  InsertReturnCostLoaded({required this.message});
}

class InsertReturnCostError extends InsertReturnCost {
  final String message;

  InsertReturnCostError({required this.message});
}
