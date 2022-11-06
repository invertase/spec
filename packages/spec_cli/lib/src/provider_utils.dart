import 'package:riverpod/riverpod.dart';

AsyncValue<T> merge<T>(T Function(R Function<R>(AsyncValue<R>) unwrap) cb) {
  try {
    R unwrap<R>(AsyncValue<R> asyncValue) {
      return asyncValue.map(
        data: (d) => d.value,
        // ignore: only_throw_errors, replace with Error.throwWithStackTrace when using higher SDK version
        error: (e) => throw e.error,
        // ignore: only_throw_errors
        loading: (l) => throw l,
      );
    }

    return AsyncData(cb(unwrap));
  } on AsyncError catch (e) {
    return AsyncError(e.error, e.stackTrace);
  } on AsyncLoading {
    return AsyncLoading<T>();
  } catch (err, stack) {
    return AsyncError<T>(err, stack);
  }
}
