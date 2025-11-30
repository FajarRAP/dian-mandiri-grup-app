import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/usecases/fetch_supplier_use_case.dart';

part 'supplier_detail_state.dart';

class SupplierDetailCubit extends Cubit<SupplierDetailState> {
  SupplierDetailCubit({required FetchSupplierUseCase fetchSupplierUseCase})
    : _fetchSupplierUseCase = fetchSupplierUseCase,
      super(const SupplierDetailState());

  final FetchSupplierUseCase _fetchSupplierUseCase;

  Future<void> fetchSupplier({required String supplierId}) async {
    emit(state.copyWith(status: .inProgress));

    final params = FetchSupplierUseCaseParams(supplierId: supplierId);
    final result = await _fetchSupplierUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (supplier) => emit(state.copyWith(status: .success, supplier: supplier)),
    );
  }
}
