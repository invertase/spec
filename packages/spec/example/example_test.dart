import 'package:spec/spec.dart';

void main() {
  test('example', () {
    var count = 0;

    expect(count).toEqual(0);

    count++;

    expect(count).not.toEqual(0);
    expect(count).toEqual(1);
  });

  test('async example', () async {
    final future = Future.value(42);

    // await expect(future).toEqual(42); // does not compile
    await expect(future).resolve.toEqual(42); // OK

    // expect(42).resolve.toEqual(42); // does not compile
  });
}
