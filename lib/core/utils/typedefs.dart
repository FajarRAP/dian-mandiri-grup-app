import 'package:dartz/dartz.dart';

import '../common/dropdown_entity.dart';
import '../errors/failure.dart';

typedef JsonMap = Map<String, dynamic>;

typedef ListJsonMap = List<Map<String, dynamic>>;

typedef ListJsonMapNullable = List<Map<String, dynamic>?>;

typedef ListDropdownUseCase = Future<Either<Failure, List<DropdownEntity>>>;

extension JsonParser on JsonMap {
  DateTime? toNullableDateTime(String key) {
    if (this[key] is String) {
      return DateTime.tryParse(this[key]);
    }

    return null;
  }
}
