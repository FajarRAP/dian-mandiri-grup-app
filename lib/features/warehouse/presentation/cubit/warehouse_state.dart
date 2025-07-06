part of 'warehouse_cubit.dart';

@immutable
sealed class WarehouseState {}

final class WarehouseInitial extends WarehouseState {}

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

class FetchPurchaseNote extends WarehouseState {}

class FetchPurchaseNoteLoading extends FetchPurchaseNote {}

class FetchPurchaseNoteLoaded extends FetchPurchaseNote {
  final PurchaseNoteDetailEntity purchaseNote;

  FetchPurchaseNoteLoaded({required this.purchaseNote});
}

class FetchPurchaseNoteError extends FetchPurchaseNote {
  final String message;

  FetchPurchaseNoteError({required this.message});
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
  final String message;

  InsertPurchaseNoteFileError({required this.message});
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
