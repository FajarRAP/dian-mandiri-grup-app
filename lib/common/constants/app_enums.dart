enum SortOptions {
  nameAsc('name,asc', 'Nama (A-Z)'),
  nameDesc('name,desc', 'Nama (Z-A)'),
  dateAsc('created_at,asc', 'Tanggal (Terlama)'),
  dateDesc('created_at,desc', 'Tanggal (Terbaru)'),
  totalItemAsc('total_items,asc', 'Total Item (Rendah ke Tinggi)'),
  totalItemDesc('total_items,desc', 'Total Item (Tinggi ke Rendah)');

  const SortOptions(this.apiValue, this.label);

  final String apiValue;
  final String label;

  List<String> get parseApiValue => apiValue.split(',');

  static List<SortOptions> get all => values;
  static List<SortOptions> get byName => [nameAsc, nameDesc];
  static List<SortOptions> get byDate => [dateAsc, dateDesc];
  static List<SortOptions> get byTotalItems => [totalItemAsc, totalItemDesc];
}

enum OpenFileStatus { success, failure, noAppToOpen }

enum ShareFileStatus { success, failure, cancelled }
