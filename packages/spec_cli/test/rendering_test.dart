import 'package:spec_cli/src/renderer.dart';
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

    test('supports empty lines', () {
      expect(
        computeOutputHeight('''
1

3

5''', terminalWidth: 80),
        5,
      );
    });

    test('handles line overflow', () {
      // Should render as:
      // 123
      // 45
      // 678
      // 90
      final output = '''
12345
67890''';
      expect(
        computeOutputHeight(output, terminalWidth: 3),
        4,
      );
    });
  });
}
