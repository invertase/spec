abstract class VT100 {
  static const esc = '\x1B';
  static const String clearScreen = '$esc[2J';
  static const String moveCursorToTopLeft = '$esc[H';

  static const String clearScreenFromCursorDown = '$esc[J';

  static String moveCursorUp(int lines) {
    return '${VT100.esc}[${lines}A';
  }

  static String moveCursorToColumn(int column) {
    return '${VT100.esc}[${column}G';
  }
}
