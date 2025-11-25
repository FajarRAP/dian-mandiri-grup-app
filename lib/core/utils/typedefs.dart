typedef JsonMap = Map<String, dynamic>;

typedef ListJsonMap = List<Map<String, dynamic>>;

typedef ListJsonMapNullable = List<Map<String, dynamic>?>;

extension JsonParser on JsonMap {
  DateTime? toNullableDateTime(String key) {
    if (this[key] is String) {
      return DateTime.tryParse(this[key]);
    }

    return null;
  }
}
