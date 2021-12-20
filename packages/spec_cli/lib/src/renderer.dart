import 'dart:io';

import 'package:cli_util/cli_logging.dart';

import 'vt100.dart';

Renderer? rendererOverride;

abstract class Renderer {
  void renderFrame(String output);
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
      ..write(
        '${VT100.moveCursorToTopLeft}${VT100.clearScreenFromCursorDown}',
      )
      ..writeln(output);
  }
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
      final lastOutputHeight = _lastFrame!.split('\n').length;
      stdout.write(VT100.moveCursorUp(lastOutputHeight));
    }
    stdout.writeln(VT100.clearScreenFromCursorDown);

    _lastFrame = output;
  }
}
