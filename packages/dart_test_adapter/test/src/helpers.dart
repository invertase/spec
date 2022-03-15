import 'package:dart_test_adapter/src/sdk_lookup.dart';
import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';

/// Creates an **empty** temp dir.
///
/// Returns the underlying folder for the created temp dir.
Directory setupTmpDir({required String dirName}) {
  final tmpDir = Directory(p.join(Directory.systemTemp.path, dirName));
  if (tmpDir.existsSync()) tmpDir.deleteSync(recursive: true);
  return tmpDir..createSync(recursive: true);
}

extension FakeSdk on Sdk {
  /// Creates a fake [Sdk] executable within the given [dir] and with the given
  /// [extension].
  ///
  /// Returns the underlying file linked to the created fake executable.
  File setupFakeExecutable({
    required Directory dir,
    required String extension,
  }) {
    final executableName = p.setExtension(name, extension);
    final executablePath = p.join(dir.path, executableName);
    final executable = File(executablePath);
    if (executable.existsSync()) executable.delete(recursive: true);
    return executable..createSync(recursive: true);
  }
}
