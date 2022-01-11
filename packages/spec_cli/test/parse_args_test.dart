import 'package:spec_cli/src/command_runner.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

void main() {
  group('SpecOptions.fromArgs', () {
    test('supports empty args', () {
      expect(
        SpecOptions.fromArgs([]),
        const SpecOptions(),
      );
    });

    test('can specify test names', () {
      expect(
        SpecOptions.fromArgs(['--name=foo', '--name=bar']),
        const SpecOptions(
          testNameFilters: ['foo', 'bar'],
        ),
      );
    });

    test('can specify file filters', () {
      expect(
        SpecOptions.fromArgs(['test/my_test.dart', 'test/dir/**.dart']),
        const SpecOptions(
          fileFilters: ['test/my_test.dart', 'test/dir/**.dart'],
        ),
      );
    });

    test('can specify --coverage', () {
      expect(
        SpecOptions.fromArgs(['--coverage']),
        const SpecOptions(coverage: true),
      );
    });

    test('can specify --watch', () {
      expect(
        SpecOptions.fromArgs(['--watch']),
        const SpecOptions(watch: true),
      );
      expect(
        SpecOptions.fromArgs(['-w']),
        const SpecOptions(watch: true),
      );
    });
  });
}
