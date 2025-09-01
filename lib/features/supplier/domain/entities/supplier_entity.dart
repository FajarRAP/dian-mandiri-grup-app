class SupplierEntity {
  final String? id;
  final String? avatarUrl;
  final String name;
  final String phoneNumber;

  const SupplierEntity({
    this.id,
    this.avatarUrl,
    required this.name,
    required this.phoneNumber,
  });
}
