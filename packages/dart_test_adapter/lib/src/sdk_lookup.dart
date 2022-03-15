import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';

/// An SDK.
enum Sdk {
  /// The Dart SDK.
  dart,

  /// The Flutter SDK.
  flutter,
}

/// {@template sdk_not_found_exception}
/// The exception thrown when and [Sdk] is not found.
/// {@endtemplate}
class SdkNotFoundException implements Exception {
  /// {@macro sdk_not_found_exception}
  const SdkNotFoundException({
    required this.sdk,
  });

  /// The [Sdk] that was not found.
  final Sdk sdk;

  @override
  String toString() => '''
${sdk.capitalizedName} SDK not found.
Verify that the SDK path has been added to your PATH environment variable.''';
}

/// A set of utilities for working with an [Sdk].
extension ExtendedSdk on Sdk {
  /// The capitalized name of the [Sdk].
  String get capitalizedName => [
        name[0].toUpperCase(),
        name.substring(1),
      ].join();

  /// The collection of valid extensions for the [Sdk] according to the current
  /// platform.
  ///
  /// The [Sdk]s installation always includes executables for all the supported
  /// platforms. This set of extensions is used to determine which of those are
  /// valid for the current platform.
  Iterable<String> get _extensions =>
      Platform.isWindows ? ['.bat', '.exe'] : ['.sh', ''];

  /// The lookup command according to the current platform.
  static final _lookupCommand = Platform.isWindows ? 'where.exe' : 'which';

  static const _lineSplitter = LineSplitter();

  /// The collection of valid executable paths for the [Sdk].
  ///
  /// Might be empty if the [Sdk] is not found.
  Future<Iterable<String>> getExecutablePaths({
    required Map<String, String>? env,
  }) async {
    final commandLookupResult = await Process.run(
      _lookupCommand,
      [name],
      environment: env,
    );
    final commandPaths = _lineSplitter
        .convert(commandLookupResult.stdout as String)
        .where((s) => _extensions.any((ext) => p.extension(s) == ext));
    return commandPaths;
  }

  /// The default [Sdk] executable path.
  ///
  /// Throws [SdkNotFoundException] if the [Sdk] is not found.
  Future<String> getDefaultExecutablePath({
    required Map<String, String>? env,
  }) async {
    final paths = await getExecutablePaths(env: env);
    if (paths.isEmpty) throw SdkNotFoundException(sdk: this);
    return paths.first;
  }
}
