import 'package:spec_cli/src/command_runner.dart';
import 'package:test/test.dart';

void main() {
  group('SpecOptions.fromArgs', () {
    test('supports empty args', () {
      expect(
        SpecOptions.fromArgs(const []),
        const SpecOptions(),
      );
    });

    test('can specify test names', () {
      expect(
        SpecOptions.fromArgs(const ['--name=foo', '--name=bar']),
        const SpecOptions(
          testNameFilters: ['foo', 'bar'],
        ),
      );
    });

    test('can specify file filters', () {
      expect(
        SpecOptions.fromArgs(const ['test/my_test.dart', 'test/dir/**.dart']),
        const SpecOptions(
          fileFilters: ['test/my_test.dart', 'test/dir/**.dart'],
        ),
      );
    });

    test('can specify --ci', () {
      expect(
        SpecOptions.fromArgs(const ['--ci']),
        const SpecOptions(ci: true),
      );
      expect(
        SpecOptions.fromArgs(const []),
        // ignore: avoid_redundant_argument_values
        const SpecOptions(ci: null),
      );
      expect(
        SpecOptions.fromArgs(const ['--no-ci']),
        const SpecOptions(ci: false),
      );
    });

    test('can specify --watch', () {
      expect(
        SpecOptions.fromArgs(const ['--watch']),
        const SpecOptions(watch: true),
      );
      expect(
        SpecOptions.fromArgs(const ['-w']),
        const SpecOptions(watch: true),
      );
    });
  });
}
