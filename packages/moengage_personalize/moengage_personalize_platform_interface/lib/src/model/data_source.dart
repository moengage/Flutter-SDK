/// Source from which experience data was retrieved.
enum DataSource {
  /// Data was served from the local cache.
  cache,

  /// Data was fetched from the network.
  network,
}

/// Extension for [DataSource] serialization.
extension DataSourceExt on DataSource {
  /// Get [DataSource] from a JSON string value.
  static DataSource fromString(String value) {
    switch (value) {
      case _valueCache:
        return DataSource.cache;
      case _valueNetwork:
        return DataSource.network;
      default:
        return DataSource.network;
    }
  }
}

const String _valueCache = 'CACHE';
const String _valueNetwork = 'NETWORK';
