import 'dart:math';

import 'package:spec_cli/src/renderer.dart';

void main() async {
  final renderer = BacktrackingRenderer();
  const sentence = 'W Szczebrzeszynie chrzaszcz brzmi w trzcinie';

  final words = sentence.split(' ');
  final longestWord = words.map((e) => e.length).reduce(max);

  for (var i = 1; i <= longestWord; i++) {
    final sb = StringBuffer();
    final renderWords =
        words.map((e) => e.substring(0, min(i, e.length))).toList();
    sb.writeAll(renderWords, '\n');

    renderer.renderFrame(sb.toString());
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}

// Future<void> main() async {
//   final log = Logger();

//   final progress = log.progress('Downloading file');

//   unawaited(Future.delayed(const Duration(milliseconds: 500), () async {
//     print('will clear screen!');
//     await Future<void>.delayed(const Duration(seconds: 1));
//     stdout.write(VT100.clearScreen);
//   }));

//   log.info('Text that appears when Progress is spinning');
//   print('Text that appears when Progress is spinning');
//   print('Text that appears when Progress is spinning');

//   await Future<void>.delayed(const Duration(seconds: 3));

//   progress.complete('Downloaded file');
// }
