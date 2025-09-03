import 'supplier_entity.dart';

class SupplierDetailEntity extends SupplierEntity {
  const SupplierDetailEntity({
    required super.id,
    super.avatarUrl,
    required super.name,
    required super.phoneNumber,
    this.address,
    this.email,
  });

  final String? address;
  final String? email;
}
