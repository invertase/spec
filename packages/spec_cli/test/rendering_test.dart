import 'package:ansi_styles/extension.dart';
import 'package:spec_cli/src/renderer.dart';
import 'package:spec_cli/src/vt100.dart';
import 'package:test/test.dart';

void main() {
  group('computeOutputHeight', () {
    test('handles newlines', () {
      expect(
        computeOutputHeight('''
1
2
3
4''', terminalWidth: 80),
        4,
      );
    });

    test('excludes invisible characters', () {
      expect(
        computeOutputHeight('''
12345${VT100.clearScreen}
world''', terminalWidth: 5),
        2,
      );
    });

    test('supports empty lines', () {
      expect(
        computeOutputHeight('''
1

3

5''', terminalWidth: 80),
        5,
      );

      expect(computeOutputHeight('', terminalWidth: 5), 0);
    });

    test('handles line overflow', () {
      // Should render as:
      // 123
      // 45
      // 678
      // 90
      const output = '''
12345
67890''';
      expect(
        computeOutputHeight(output, terminalWidth: 3),
        4,
      );
    });
  });

  test('contentAfterFirstLineDiff', () {
    expect(
      contentAfterFirstLineDiff(
        previous: 'abc\ndef\ng',
        next: 'abc\ndei\ng',
      ),
      Diff(
        previous: 'def\ng',
        next: 'dei\ng',
      ),
    );

    expect(
      contentAfterFirstLineDiff(
        previous: 'a',
        next: '''
a
b
c''',
      ),
      isA<Diff>()
          .having((e) => e.previous, 'previous', '')
          .having((e) => e.next, 'next', '''

b
c'''),
      reason: 'Since `previous` had no newline at its end '
          'but `next` added one, it is preserved',
    );

    expect(
      contentAfterFirstLineDiff(
        previous: '',
        next: '\n',
      ),
      Diff(
        previous: '',
        next: '\n',
      ),
    );

    expect(
      contentAfterFirstLineDiff(
        previous: '''
 ${'PASS'.bgGreen.black.bold} test/foo.dart

 ${'RUNS'.bgYellow.black.bold} test/bar.dart
''',
        next: '''
 ${'PASS'.bgGreen.black.bold} test/foo.dart
 ${'PASS'.bgGreen.black.bold} test/bar.dart
''',
      ),
      Diff(
        previous: '''

 ${'RUNS'.bgYellow.black.bold} test/bar.dart
''',
        next: '''
 ${'PASS'.bgGreen.black.bold} test/bar.dart
''',
      ),
    );

    expect(
      contentAfterFirstLineDiff(
        previous: '\n',
        next: '\n',
      ),
      Diff(
        previous: '',
        next: '',
      ),
    );

    expect(
      contentAfterFirstLineDiff(
        previous: '\n',
        next: '\n\n',
      ),
      Diff(
        previous: '',
        next: '\n',
      ),
    );

    expect(
      contentAfterFirstLineDiff(
        previous: '\n\n',
        next: '\n',
      ),
      Diff(
        previous: '\n',
        next: '',
      ),
    );
  });
}
