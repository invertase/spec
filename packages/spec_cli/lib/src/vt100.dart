abstract class VT100 {
  static const ESC = '\x1B';
  static const String clearScreen = '$ESC[2J';
  static const String moveCursorToTopLeft = '$ESC[H';

  static const String clearScreenFromCursorDown = '$ESC[J';

  static String moveCursorUp(int lines) {
    return '${VT100.ESC}[${lines}A';
  }

  static String moveCursorToColumn(int column) {
    return '${VT100.ESC}[${column}G';
  }
}
