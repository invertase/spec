import 'package:dart_test_adapter/src/sdk_lookup.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import 'helpers.dart';

void main() {
  for (final sdk in Sdk.values) {
    group('${sdk.capitalizedName} SDK executables lookup', () {
      final extensionCases = Platform.isWindows
          ? [
              ['.exe', '.bat'],
              ['.bat', '.exe'],
            ]
          : [
              ['.sh', ''],
              ['', '.sh'],
            ];

      for (var caseIdx = 0; caseIdx < extensionCases.length; caseIdx++) {
        final extensions = extensionCases[caseIdx];
        test(
            'returns a set of executable paths when found, keeping their '
            'priority order', () async {
          final executableDirPaths = <String>[];
          final executablePaths = <String>[];
          for (var extIdx = 0; extIdx < extensions.length; extIdx++) {
            final executableDirName = '${sdk.name}-all-$caseIdx-$extIdx';
            final executableDir = setupTmpDir(dirName: executableDirName);
            final extension = extensions[extIdx];
            final executable = sdk.setupFakeExecutable(
              dir: executableDir,
              extension: extension,
            );
            executableDirPaths.add(executableDir.path);
            executablePaths.add(executable.path);
          }
          final env = <String, String>{
            'PATH': executableDirPaths.join(Platform.isWindows ? ';' : ':'),
          };
          final foundExecutablePaths = await sdk.getExecutablePaths(env: env);
          expect(foundExecutablePaths, executablePaths);
        });
      }

      test('returns an empty collection of executable paths when not found',
          () async {
        final executablesDir = setupTmpDir(dirName: '${sdk.name}-none');
        final env = <String, String>{'PATH': executablesDir.path};
        final executablePaths = await sdk.getExecutablePaths(env: env);
        expect(executablePaths, isEmpty);
      });
    });

    group('${sdk.capitalizedName} SDK default executable lookup', () {
      test('returns the prime valid executable path when found', () async {
        final extensions = Platform.isWindows ? ['.bat', '.exe'] : ['.sh', ''];
        final executableDirPaths = <String>[];
        final executablePaths = <String>[];
        for (var extIdx = 0; extIdx < extensions.length; extIdx++) {
          final executableDirName = '${sdk.name}-default-$extIdx';
          final executableDir = setupTmpDir(dirName: executableDirName);
          final extension = extensions[extIdx];
          final executable = sdk.setupFakeExecutable(
            dir: executableDir,
            extension: extension,
          );
          executableDirPaths.add(executableDir.path);
          executablePaths.add(executable.path);
        }
        final env = <String, String>{
          'PATH': executableDirPaths.join(Platform.isWindows ? ';' : ':'),
        };
        final foundExecutablePath =
            await sdk.getDefaultExecutablePath(env: env);
        expect(foundExecutablePath, executablePaths.first);
      });

      test('throws an [SdkNotFoundException] when no prime executable is found',
          () async {
        final executablesDir = setupTmpDir(dirName: '${sdk.name}-throw');
        final env = <String, String>{'PATH': executablesDir.path};
        Future<void> defaultExecutableLookup() =>
            sdk.getDefaultExecutablePath(env: env);
        final errorMsg = '''
${sdk.capitalizedName} SDK not found.
Verify that the SDK path has been added to your PATH environment variable.''';
        expect(
          defaultExecutableLookup,
          throwsA(
            isA<SdkNotFoundException>()
                .having((e) => e.sdk, 'sdk', sdk)
                .having((e) => e.toString(), 'message', errorMsg),
          ),
        );
      });
    });
  }
}
