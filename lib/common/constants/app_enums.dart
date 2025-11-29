enum SortOptions {
  nameAsc('name,asc', 'Nama (A-Z)'),
  nameDesc('name,desc', 'Nama (Z-A)'),
  dateAsc('created_at,asc', 'Tanggal (Terlama)'),
  dateDesc('created_at,desc', 'Tanggal (Terbaru)');

  const SortOptions(this.apiValue, this.label);

  final String apiValue;
  final String label;

  List<String> get parseApiValue => apiValue.split(',');

  static List<SortOptions> get all => values;
  static List<SortOptions> get byName => [nameAsc, nameDesc];
  static List<SortOptions> get byDate => [dateAsc, dateDesc];
}
