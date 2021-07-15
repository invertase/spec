import 'package:spec/spec.dart';

void main() {
  test('example', () {
    var count = 0;

    expect(count).toEqual(0);

    count++;

    expect(count).not.toEqual(0);
    expect(count).toEqual(1);
  });

  test('future example', () async {
    final future = Future.value(42);

    // await expect(future).toEqual(42); // does not compile
    expect(future).toEqual(future); // OK

    await expect(future).completion.toEqual(42);
    // expect(42).resolve.toEqual(42); // does not compile

    await expect(future).throws.isArgumentError();
  });

  test('stream example', () async {
    final stream = Stream.value(42);

    await expect(stream).emits.toEqual(42);
    await expect(stream).emits.isNull();
    await expect(stream).emits.not.isNull();

    await expect(stream).emitsError.isArgumentError();
  });

  test('function example', () {
    void throwsFn() => throw Error();

    expect(throwsFn).returnsNormally();
    expect(throwsFn).throws.isArgumentError();
  });

  test('num example', () {
    expect(42).toEqual(42);
    expect(42).lessThan(42);
  });

  test('bool example', () {
    expect(true).isTrue();
  });

  test('string example', () {
    expect('hello').equalsIgnoringCase('HELLO');
  });
}
