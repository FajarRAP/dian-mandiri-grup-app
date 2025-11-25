import 'package:equatable/equatable.dart';

class SupplierEntity extends Equatable {
  const SupplierEntity({
    required this.id,
    this.avatarUrl,
    required this.name,
    required this.phoneNumber,
  });

  final String id;
  final String? avatarUrl;
  final String name;
  final String phoneNumber;

  @override
  List<Object?> get props => [id, avatarUrl, name, phoneNumber];
}
