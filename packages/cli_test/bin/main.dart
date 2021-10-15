import 'dart:io';

void main() {
  print('''
my_test:
hasTerminal: ${stdout.hasTerminal}
supportsAnsiEscapes: ${stdout.supportsAnsiEscapes}
encoding: ${stdout.encoding}
''');
}
