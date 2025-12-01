import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/usecases/create_supplier_use_case.dart';

part 'create_supplier_state.dart';

class CreateSupplierCubit extends Cubit<CreateSupplierState> {
  CreateSupplierCubit({required CreateSupplierUseCase createSupplierUseCase})
    : _createSupplierUseCase = createSupplierUseCase,
      super(const CreateSupplierState());

  final CreateSupplierUseCase _createSupplierUseCase;

  Future<void> createSupplier({
    required String name,
    required String phoneNumber,
    String? address,
    String? avatar,
    String? email,
  }) async {
    emit(state.copyWith(status: .inProgress));

    final params = CreateSupplierUseCaseParams(
      name: name,
      phoneNumber: phoneNumber,
      address: address,
      avatar: avatar,
      email: email,
    );
    final result = await _createSupplierUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (message) => emit(state.copyWith(status: .success, message: message)),
    );
  }
}
