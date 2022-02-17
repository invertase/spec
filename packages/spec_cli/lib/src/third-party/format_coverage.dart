import 'dart:io';

import 'package:coverage/coverage.dart';

Future<void> formatCoverage({
  required String input,
  required String packagesPath,
  required List<String> reportOn,
  required String output,
}) async {
  final files = filesToProcess(input);

  final hitmap = await HitMap.parseFiles(
    files,
    packagesPath: packagesPath,
  );

  final resolver = Resolver(packagesPath: packagesPath);
  final result = hitmap.formatLcov(
    resolver,
    reportOn: reportOn,
  );

  final file = File(output)..createSync(recursive: true);
  final sink = file.openWrite();

  sink.write(result);
  await sink.flush();
  await sink.close();
}

/// Given an absolute path absPath, this function returns a [List] of files
/// are contained by it if it is a directory, or a [List] containing the file if
/// it is a file.
List<File> filesToProcess(String absPath) {
  if (FileSystemEntity.isDirectorySync(absPath)) {
    return Directory(absPath)
        .listSync(recursive: true)
        .whereType<File>()
        .where((e) => e.path.endsWith('.json'))
        .toList();
  }
  return <File>[File(absPath)];
}
