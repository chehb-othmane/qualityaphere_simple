// had les exceptions ghankhdem bihom f datasource w nrdhom failures f repository

class ServerException implements Exception {
  final String? message;
  ServerException([this.message]);

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String? message;
  CacheException([this.message]);

  @override
  String toString() => 'CacheException: $message';
}
