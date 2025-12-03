import 'package:equatable/equatable.dart';

import '../../utils/typedefs.dart';

class DropdownEntity extends Equatable {
  const DropdownEntity({
    required this.key,
    required this.value,
  });

  factory DropdownEntity.fromJson(JsonMap json) {
    return DropdownEntity(
      key: json['key'],
      value: json['value'],
    );
  }

  final String key;
  final String value;

  @override
  List<Object?> get props => [key, value];
}
