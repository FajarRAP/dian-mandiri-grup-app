part of 'import_purchase_note_cubit.dart';

enum ImportPurchaseNoteStatus { initial, inProgress, success, failure }

class ImportPurchaseNoteState extends Equatable {
  const ImportPurchaseNoteState({
    this.status = .initial,
    this.supplier,
    this.date,
    this.image,
    this.note,
    this.file,
    this.message,
    this.failure,
  });

  // Status
  final ImportPurchaseNoteStatus status;

  // State Properties
  final DropdownEntity? supplier;
  final DateTime? date;
  final File? image;
  final String? note;
  final File? file;

  // Success
  final String? message;

  // Failure
  final Failure? failure;

  bool shouldListen(ImportPurchaseNoteState previous) {
    return previous.supplier != supplier ||
        previous.date != date ||
        previous.image != image ||
        previous.file != file;
  }

  ImportPurchaseNoteState copyWith({
    ImportPurchaseNoteStatus? status,
    DropdownEntity? supplier,
    DateTime? date,
    File? image,
    String? note,
    File? file,
    String? message,
    Failure? failure,
  }) {
    return ImportPurchaseNoteState(
      status: status ?? this.status,
      supplier: supplier ?? this.supplier,
      date: date ?? this.date,
      image: image ?? this.image,
      note: note ?? this.note,
      file: file ?? this.file,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    supplier,
    date,
    image,
    note,
    file,
    message,
    failure,
  ];
}
