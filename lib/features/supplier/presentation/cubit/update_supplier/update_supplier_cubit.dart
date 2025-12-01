import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/usecases/update_supplier_use_case.dart';

part 'update_supplier_state.dart';

class UpdateSupplierCubit extends Cubit<UpdateSupplierState> {
  UpdateSupplierCubit({required UpdateSupplierUseCase updateSupplierUseCase})
    : _updateSupplierUseCase = updateSupplierUseCase,
      super(const UpdateSupplierState());

  final UpdateSupplierUseCase _updateSupplierUseCase;

  Future<void> updateSupplier({
    required String id,
    required String name,
    required String phoneNumber,
    String? address,
    String? avatar,
    String? email,
  }) async {
    emit(state.copyWith(status: .inProgress));

    final params = UpdateSupplierUseCaseParams(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      address: address,
      email: email,
      avatar: avatar,
    );
    final result = await _updateSupplierUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (message) => emit(state.copyWith(status: .success, message: message)),
    );
  }
}
