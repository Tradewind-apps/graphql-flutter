import 'dart:async';
import 'package:meta/meta.dart';

import 'package:hive/hive.dart';

import './store.dart';

@immutable
class HiveStore extends Store {
  /// Default box name for the `graphql/client.dart` cache store (`graphqlClientStore`)
  static const defaultBoxName = 'graphqlClientStore';

  /// Opens a box. Convenience pass through to [Hive.openBox].
  ///
  /// If the box is already open, the instance is returned and all provided parameters are being ignored.
  static final openBox = Hive.openBox;

  /// Create a [HiveStore] with a [Box] with the given [boxName] (defaults to [defaultBoxName])
  /// box from [openBox(boxName)]
  static Future<HiveStore> open([
    String boxName = defaultBoxName,
  ]) async =>
      HiveStore(await openBox(boxName));

  @protected
  final Box box;

  /// Creates a HiveStore inititalized with [box],
  HiveStore(this.box);

  @override
  Map<String, dynamic> get(String dataId) {
    final result = box.get(dataId);
    if (result == null) return null;
    return Map.from(result);
  }

  @override
  void put(String dataId, Map<String, dynamic> value) {
    box.put(dataId, value);
  }

  @override
  void putAll(Map<String, Map<String, dynamic>> data) {
    box.putAll(data);
  }

  @override
  void delete(String dataId) {
    box.delete(dataId);
  }

  @override
  Map<String, Map<String, dynamic>> toMap() => Map.unmodifiable(box.toMap());

  void reset() => box.clear();
}
