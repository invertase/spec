import 'dart:io';
import 'dart:math';

import 'package:cli_util/cli_logging.dart';

import 'vt100.dart';

Renderer? rendererOverride;

// ignore: one_member_abstracts, may have more methods in the future
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
    // TODO update renderer to use ansi to only output the diff of the previous vs new frame
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
  // For some reasons, going from first frame to second frame clears one more line
  // than needed. This workaround fixes it.
  var _didAddOneLine = false;

  @override
  void renderFrame(String output) {
    // TODO fix update incorrectly overriding terminal prompt
    if (_lastFrame != null) {
      final lastOutputHeight = computeOutputHeight(
        _lastFrame!,
        terminalWidth: stdout.terminalColumns,
      );

      final inc = _didAddOneLine ? 1 : 2;
      _didAddOneLine = true;

      stdout.write(
        VT100.moveCursorUp(lastOutputHeight - inc) +
            VT100.moveCursorToColumn(0),
      );
      stdout.write(VT100.clearScreenFromCursorDown);
    }
    // TODO update renderer to use ansi to only output the diff of the previous vs new frame
    if (_lastFrame == null) stdout.write('first render');
    stdout.write(output);

    _lastFrame = output;
  }
}
