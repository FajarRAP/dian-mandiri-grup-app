class DropdownEntity {
  final String key;
  final String value;

  const DropdownEntity({
    required this.key,
    required this.value,
  });

  factory DropdownEntity.fromJson(Map<String, dynamic> json) => DropdownEntity(
        key: json['key'],
        value: json['value'],
      );
}
