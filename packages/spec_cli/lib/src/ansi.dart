import 'package:ansi_styles/ansi_styles.dart';

extension AnsiExt on String {
  String get reset => AnsiStyles.reset(this);
  String get bold => AnsiStyles.bold(this);
  String get dim => AnsiStyles.dim(this);
  String get italic => AnsiStyles.italic(this);
  String get underline => AnsiStyles.underline(this);
  String get blink => AnsiStyles.blink(this);
  String get inverse => AnsiStyles.inverse(this);
  String get hidden => AnsiStyles.hidden(this);
  String get strikethrough => AnsiStyles.strikethrough(this);
  String get black => AnsiStyles.black(this);
  String get red => AnsiStyles.red(this);
  String get green => AnsiStyles.green(this);
  String get yellow => AnsiStyles.yellow(this);
  String get blue => AnsiStyles.blue(this);
  String get magenta => AnsiStyles.magenta(this);
  String get cyan => AnsiStyles.cyan(this);
  String get white => AnsiStyles.white(this);
  String get blackBright => AnsiStyles.blackBright(this);
  String get redBright => AnsiStyles.redBright(this);
  String get greenBright => AnsiStyles.greenBright(this);
  String get yellowBright => AnsiStyles.yellowBright(this);
  String get blueBright => AnsiStyles.blueBright(this);
  String get magentaBright => AnsiStyles.magentaBright(this);
  String get cyanBright => AnsiStyles.cyanBright(this);
  String get whiteBright => AnsiStyles.whiteBright(this);
  String get bgBlack => AnsiStyles.bgBlack(this);
  String get bgRed => AnsiStyles.bgRed(this);
  String get bgGreen => AnsiStyles.bgGreen(this);
  String get bgYellow => AnsiStyles.bgYellow(this);
  String get bgBlue => AnsiStyles.bgBlue(this);
  String get bgMagenta => AnsiStyles.bgMagenta(this);
  String get bgCyan => AnsiStyles.bgCyan(this);
  String get bgWhite => AnsiStyles.bgWhite(this);
  String get bgBlackBright => AnsiStyles.bgBlackBright(this);
  String get bgRedBright => AnsiStyles.bgRedBright(this);
  String get bgGreenBright => AnsiStyles.bgGreenBright(this);
  String get bgYellowBright => AnsiStyles.bgYellowBright(this);
  String get bgBlueBright => AnsiStyles.bgBlueBright(this);
  String get bgMagentaBright => AnsiStyles.bgMagentaBright(this);
  String get bgCyanBright => AnsiStyles.bgCyanBright(this);
  String get bgWhiteBright => AnsiStyles.bgWhiteBright(this);
  String get grey => AnsiStyles.grey(this);
  String get bgGrey => AnsiStyles.bgGrey(this);
  String get gray => AnsiStyles.gray(this);
  String get bgGray => AnsiStyles.bgGray(this);

  String get withoutAnsi => replaceAll(_ansiRegex, '');
}

// Cloned from https://github.com/chalk/ansi-regex/blob/main/index.js
final _ansiRegex = RegExp(
  [
    r'[\u001B\u009B][[\]()#;?]*(?:(?:(?:(?:;[-a-zA-Z\d\\/#&.:=?%@~_]+)*|[a-zA-Z\d]+(?:;[-a-zA-Z\d\/#&.:=?%@~_]*)*)?\u0007)',
    r'(?:(?:\d{1,4}(?:;\d{0,4})*)?[\dA-PR-TZcf-nq-uy=><~]))'
  ].join('|'),
);
