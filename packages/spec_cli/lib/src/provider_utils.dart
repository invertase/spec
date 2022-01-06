import 'package:riverpod/riverpod.dart';

AsyncValue<T> merge<T>(T Function(R Function<R>(AsyncValue<R>) unwrap) cb) {
  try {
    R unwrap<R>(AsyncValue<R> asyncValue) {
      return asyncValue.map(
        data: (d) => d.value,
        error: (e) => throw e.error,
        loading: (l) => throw l,
      );
    }

    return AsyncData(cb(unwrap));
  } on AsyncError catch (e) {
    return AsyncError(e.error, stackTrace: e.stackTrace);
  } on AsyncLoading {
    return AsyncLoading();
  } catch (err, stack) {
    return AsyncError<T>(err, stackTrace: stack);
  }
}
