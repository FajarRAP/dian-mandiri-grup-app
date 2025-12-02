import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/warehouse_repository.dart';

class ImportPurchaseNoteUseCase
    implements UseCase<String, ImportPurchaseNoteUseCaseParams> {
  const ImportPurchaseNoteUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;
  @override
  Future<Either<Failure, String>> execute(
    ImportPurchaseNoteUseCaseParams params,
  ) async {
    return await warehouseRepository.importPurchaseNote(params);
  }
}

class ImportPurchaseNoteUseCaseParams extends Equatable {
  const ImportPurchaseNoteUseCaseParams({
    required this.date,
    required this.receipt,
    this.note,
    required this.supplierId,
    required this.file,
  });

  final DateTime date;
  final String receipt;
  final String? note;
  final String supplierId;
  final String file;

  @override
  List<Object?> get props => [date, receipt, note, supplierId, file];
}
