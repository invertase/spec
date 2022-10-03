import 'dart:async';

import 'package:riverpod/riverpod.dart';

final _providerContainerZoneKey = Object();

Future<T> runScoped<T>(
  FutureOr<T> Function(DartRef ref) callback, {
  List<Override> overrides = const [],
}) async {
  final parent = Zone.current._container;

  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
  );

  try {
    return await runZoned<FutureOr<T>>(
      () => callback(_DartRef()),
      zoneValues: {_providerContainerZoneKey: container},
    );
  } finally {
    container.dispose();
  }
}

extension on Zone {
  ProviderContainer? get _container =>
      this[_providerContainerZoneKey] as ProviderContainer?;
}

class _DartRef extends DartRef {}

abstract class DartRef {
  ProviderContainer get _container {
    final container = Zone.current._container;
    if (container == null) throw StateError('No ProviderContainer found');
    return container;
  }

  T read<T>(ProviderListenable<T> provider) => _container.read(provider);

  T refresh<T>(Refreshable<T> provider) => _container.refresh(provider);

  Future<void> pump() => _container.pump();

  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T current) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
  }) =>
      _container.listen<T>(
        provider,
        listener,
        fireImmediately: fireImmediately,
        onError: onError,
      );

  Stream<T> listenAsStream<T>(ProviderBase<AsyncValue<T>> provider) {
    final controller = StreamController<T>();

    late ProviderSubscription<AsyncValue<T>> sub;

    controller.onListen = () => sub = listen<AsyncValue<T>>(
          provider,
          (prev, value) {
            value.when(
              data: controller.add,
              error: controller.addError,
              loading: () {},
            );
          },
        );
    controller.onCancel = () {
      sub.close();
      controller.close();
    };

    return controller.stream;
  }
}
