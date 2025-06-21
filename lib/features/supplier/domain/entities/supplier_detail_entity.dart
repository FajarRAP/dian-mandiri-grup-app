import 'supplier_entity.dart';

class SupplierDetailEntity extends SupplierEntity {
  const SupplierDetailEntity({
    required super.id,
    required super.avatarUrl,
    required super.name,
    required super.phoneNumber,
    required this.address,
    required this.email,
  });

  final String address;
  final String email;
}
