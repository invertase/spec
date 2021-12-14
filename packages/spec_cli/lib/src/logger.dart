import 'package:cli_util/cli_logging.dart';
import 'package:riverpod/riverpod.dart';

final loggerProvider = Provider<Logger>((ref) => Logger.standard());
