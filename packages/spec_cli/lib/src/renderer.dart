// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:io';
import 'dart:math';

import 'package:ansi_styles/extension.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
      ..write(output);
  }
}

int computeOutputHeight(String output, {required int terminalWidth}) {
  if (output.isEmpty) return 0;
  return output.strip.split('\n').fold(0, (acc, line) {
    return acc + max(1, (line.length / terminalWidth).ceil());
  });
}

Diff contentAfterFirstLineDiff({
  required String previous,
  required String next,
}) {
  var firstDiffIndex = 0;
  for (;
      firstDiffIndex < previous.length &&
          firstDiffIndex < next.length &&
          previous[firstDiffIndex] == next[firstDiffIndex];
      firstDiffIndex++) {}

  if (firstDiffIndex < previous.length) {
    var lineStartIndexAtFirstDiff = firstDiffIndex - 1;
    for (;
        lineStartIndexAtFirstDiff > 0 &&
            previous[lineStartIndexAtFirstDiff] != '\n';
        lineStartIndexAtFirstDiff--) {}

    if (lineStartIndexAtFirstDiff >= 0 &&
        previous[lineStartIndexAtFirstDiff] == '\n') {
      if (lineStartIndexAtFirstDiff + 1 < previous.length) {
        lineStartIndexAtFirstDiff++;
      }
    }

    return Diff(
      previous: previous.substring(lineStartIndexAtFirstDiff),
      next: next.substring(lineStartIndexAtFirstDiff),
    );
  }

  // No diff
  return Diff(
    previous: '',
    next: next.substring(previous.length),
  );
}

@immutable
class Diff {
  Diff({required this.previous, required this.next});

  final String previous;
  final String next;

  @override
  int get hashCode => Object.hash(runtimeType, previous, next);

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType &&
        other is Diff &&
        other.previous == previous &&
        other.next == next;
  }

  @override
  String toString() {
    return '''
Diff(
  previous: ${"'''"}
$previous
${"'''"},
  next: ${"'''"}
$next
${"'''"},
)
''';
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
    String? toRender;
    if (_lastFrame != null) {
      final diff = contentAfterFirstLineDiff(
        previous: _lastFrame!,
        next: output,
      );
      final lastOutputHeight = computeOutputHeight(
        diff.previous,
        terminalWidth: stdout.hasTerminal ? stdout.terminalColumns : 80,
      );
      toRender = diff.next;

      if (lastOutputHeight > 0) {
        if (lastOutputHeight > 1) {
          stdout.write(VT100.moveCursorUp(lastOutputHeight - 1));
        }
        stdout
          ..write(VT100.moveCursorToColumn(0))
          ..write(VT100.clearScreenFromCursorDown);
      }
    }

    stdout.write(toRender ?? output);
    _lastFrame = output;
  }
}
