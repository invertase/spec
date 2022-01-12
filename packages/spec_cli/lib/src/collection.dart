import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';

extension IterableExt<T> on Iterable<T> {
  R? firstWhereTypeOrNull<R>() {
    return firstWhereOrNull((element) => element is R) as R?;
  }

  AsyncValue<T> get firstDataOrLoading {
    if (isEmpty) return AsyncLoading<T>();
    return AsyncData(first);
  }
}
