import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:isolated_worker/isolated_worker.dart';
import 'package:isolated_worker/js_isolated_worker.dart';

const String _primaryFallbackJsonEncodeValue = '{}';
const Map _primaryFallbackJsonDecodeValue = {};

class IsolateWorker {
  static Future<dynamic> decodeJson(
    String source, {
    dynamic onFallbackValue = _primaryFallbackJsonDecodeValue,
    bool rethrowException = false,
  }) async {
    try {
      if (kIsWeb) {
        final result = await JsIsolatedWorker().run(
          functionName: ['JSON', 'parse'],
          arguments: source,
          fallback: () async => _primaryFallbackJsonDecodeValue,
        );
        return result;
      }
      final result = IsolatedWorker().run(jsonDecode, source);
      return result;
    } catch (_) {
      if (rethrowException) rethrow;
      return onFallbackValue;
    }
  }

  static Future<String> encodeJson(
    dynamic object, {
    String onFallbackValue = _primaryFallbackJsonEncodeValue,
    bool rethrowException = false,
  }) async {
    try {
      if (kIsWeb) {
        final result = await JsIsolatedWorker().run(
          functionName: ['JSON', 'stringify'],
          arguments: object,
          fallback: () async => onFallbackValue,
        );
        return result as String;
      }
      final result = await IsolatedWorker().run(jsonEncode, object);
      return result;
    } catch (_) {
      if (rethrowException) rethrow;
      return onFallbackValue;
    }
  }

  /// Method used widely for spawn isolate for heavy work
  /// Not supported yet on WEB - will throw exception
  /// Method that is passed down to run should be annotated with @pragma('vm:entry-point') decorator
  /// and should be also top level function
  static Future<T> run<T, U>(
    FutureOr<T> Function(U) function, {
    required U arguments,
  }) async {
    if (kIsWeb) {
      throw Exception('Platform not supported yet for run');
    }
    return flutterCompute(function, arguments);
  }
}
