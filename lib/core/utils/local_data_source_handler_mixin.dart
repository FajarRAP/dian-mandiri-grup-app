import '../errors/exceptions.dart';

mixin LocalDataSourceHandlerMixin {
  Future<T> handleLocalDataSourceRequest<T>(
      Future<T> Function() function) async {
    try {
      final result = await function();

      return result;
    } catch (e) {
      throw CacheException(message: 'Local data source error: $e');
    }
  }
}
