import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/domain/entities/dropdown_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/file_interaction_service.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/usecases/import_purchase_note_use_case.dart';

part 'import_purchase_note_state.dart';

class ImportPurchaseNoteCubit extends Cubit<ImportPurchaseNoteState> {
  ImportPurchaseNoteCubit({
    required ImportPurchaseNoteUseCase importPurchaseNoteUseCase,
    required FileInteractionService fileInteractionService,
  }) : _importPurchaseNoteUseCase = importPurchaseNoteUseCase,
       _fileInteractionService = fileInteractionService,
       super(const ImportPurchaseNoteState());

  final ImportPurchaseNoteUseCase _importPurchaseNoteUseCase;
  final FileInteractionService _fileInteractionService;

  Future<void> importPurchaseNote() async {
    if (state.image == null) {
      const message = 'Silakan pilih gambar nota terlebih dahulu';
      emit(
        state.copyWith(
          status: .failure,
          failure: const Failure(message: message),
        ),
      );
      return emit(state.copyWith(status: .initial));
    }

    if (state.file == null) {
      const message = 'Silakan pilih file barang terlebih dahulu';
      emit(
        state.copyWith(
          status: .failure,
          failure: const Failure(message: message),
        ),
      );
      return emit(state.copyWith(status: .initial));
    }

    emit(state.copyWith(status: .inProgress));

    final params = ImportPurchaseNoteUseCaseParams(
      date: state.date!,
      receipt: state.image!.path,
      supplierId: state.supplier!.key,
      file: state.file!.path,
      note: state.note,
    );
    final result = await _importPurchaseNoteUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (message) => emit(state.copyWith(status: .success, message: message)),
    );

    emit(state.copyWith(status: .initial));
  }

  Future<void> pickFile() async {
    final file = await _fileInteractionService.pickFile();

    emit(state.copyWith(file: file));
  }

  set supplier(DropdownEntity? supplier) =>
      emit(state.copyWith(supplier: supplier));

  set date(DateTime? date) => emit(state.copyWith(date: date));

  set image(File? image) => emit(state.copyWith(image: image));

  set note(String? note) => emit(state.copyWith(note: note));

  set file(File? file) => emit(state.copyWith(file: file));
}
