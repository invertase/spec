import 'dart:io';

void main() {
  print('''
my_test:
hasTerminal: ${stdout.hasTerminal}
nonBlocking: ${stdout.nonBlocking}
supportsAnsiEscapes: ${stdout.supportsAnsiEscapes}
terminalColumns: ${stdout.terminalColumns}
terminalLines: ${stdout.terminalLines}
encoding: ${stdout.encoding}
''');
}
