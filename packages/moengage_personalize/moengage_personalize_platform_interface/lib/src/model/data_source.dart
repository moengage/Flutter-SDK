import 'package:moengage_flutter/moengage_flutter.dart' show Logger;

import '../internal/constants.dart';

/// Source from which experience data was retrieved.
enum DataSource {
  /// Data was served from the local cache.
  cache('CACHE'),

  /// Data was fetched from the network.
  network('NETWORK');

  const DataSource(this.value);

  /// JSON string representation of this source.
  final String value;

  /// Get [DataSource] from a JSON string value.
  ///
  /// Falls back to [DataSource.network] for unknown values.
  static DataSource fromString(String str) => DataSource.values.firstWhere(
        (s) => s.value == str,
        orElse: () {
          Logger.w(
              '${moduleTag}DataSource fromString(): Unknown value "$str", defaulting to network');
          return DataSource.network;
        },
      );
}
