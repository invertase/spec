import 'dart:io';
import 'dart:math';

import 'package:cli_util/cli_logging.dart';

import 'vt100.dart';

Renderer? rendererOverride;

abstract class Renderer {
  void renderFrame(String output);
}

class DebugRenderer implements Renderer {
  @override
  void renderFrame(String output) {
    stdout.writeln('log:\n`\n$output\n`');
  }
}

class FullScreenRenderer implements Renderer {
  FullScreenRenderer()
      : assert(
          Ansi.terminalSupportsAnsi,
          'Cannot use FullScreenRenderer on terminals that do not support ANSI codes',
        );

  @override
  void renderFrame(String output) {
    stdout
      ..write('${VT100.moveCursorToTopLeft}${VT100.clearScreenFromCursorDown}')
      ..writeln(output);
  }
}

int computeOutputHeight(String output, {required int terminalWidth}) {
  return output.split('\n').fold(0, (acc, line) {
    return acc + max(1, (line.length / terminalWidth).ceil());
  });
}

/// A [Renderer] that, when a new frame is drawn, will clear previously rendered
/// content – without touching to the output of previously executed commands.
class BacktrackingRenderer implements Renderer {
  BacktrackingRenderer()
      : assert(
          Ansi.terminalSupportsAnsi,
          'Cannot use BacktrackingRenderer on terminals that do not support ANSI codes',
        );

  String? _lastFrame;

  @override
  void renderFrame(String output) {
    if (_lastFrame != null) {
      final lastOutputHeight = computeOutputHeight(
        _lastFrame!,
        terminalWidth: stdout.terminalColumns,
      );
      stdout.write(
        VT100.moveCursorUp(lastOutputHeight - 1) + VT100.moveCursorToColumn(0),
      );
    }
    stdout.write(VT100.clearScreenFromCursorDown);
    stdout.write(output);

    _lastFrame = output;
  }
}
