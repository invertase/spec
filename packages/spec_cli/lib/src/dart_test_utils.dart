import 'package:collection/collection.dart';
import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';

import 'tests.dart';

@immutable
class TestKey {
  const TestKey({
    required this.testID,
    required this.groupID,
    required this.suiteID,
  });

  final int testID;
  final int? groupID;
  final int suiteID;

  @override
  bool operator ==(Object other) =>
      other is TestKey &&
      other.runtimeType == runtimeType &&
      other.testID == testID &&
      other.groupID == groupID &&
      other.suiteID == suiteID;

  @override
  int get hashCode => Object.hash(runtimeType, testID, suiteID, groupID);
}

@immutable
class GroupKey {
  const GroupKey({
    required this.groupID,
    required this.suiteID,
  });

  final int groupID;
  final int suiteID;

  @override
  bool operator ==(Object other) =>
      other is GroupKey &&
      other.runtimeType == runtimeType &&
      other.groupID == groupID &&
      other.suiteID == suiteID;

  @override
  int get hashCode => Object.hash(runtimeType, suiteID, groupID);
}

@immutable
class SuiteKey {
  const SuiteKey({required this.suiteID});

  final int suiteID;

  @override
  bool operator ==(Object other) =>
      other is SuiteKey &&
      other.runtimeType == runtimeType &&
      other.suiteID == suiteID;

  @override
  int get hashCode => Object.hash(runtimeType, suiteID);
}

/// A value scoped to a package
@immutable
class Packaged<Value> {
  const Packaged(this.packagePath, this.value);

  final Value value;
  final String packagePath;

  Packaged<R> next<R>(R Function(Value value) cb) =>
      Packaged(packagePath, cb(value));

  @override
  bool operator ==(Object other) =>
      other is Packaged<Value> &&
      other.runtimeType == runtimeType &&
      other.packagePath == packagePath &&
      other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value, packagePath);
}

extension ObjectX<T> on T {
  R? cast<R>() => this is R ? this as R : null;
}

extension PackagedTestExt on Packaged<Test> {
  Packaged<TestKey> get key => next((t) => t.key);
  Packaged<GroupKey>? get groupKey =>
      value.groupKey == null ? null : next((t) => t.groupKey!);
  Packaged<SuiteKey> get suiteKey => next((t) => t.suiteKey);
}

extension TestExt on Test {
  // when "url" is null, it means that this is not a user-defined test
  // and is instead a setup/tearOff/.., so it doesn't count
  bool get isHidden => url == null;

  TestKey get key => TestKey(
        testID: id,
        groupID: groupIDs.isEmpty ? null : groupIDs.last,
        suiteID: suiteID,
      );

  GroupKey? get groupKey => groupIDs.isEmpty
      ? null
      : GroupKey(suiteID: suiteID, groupID: groupIDs.last);

  SuiteKey get suiteKey => SuiteKey(suiteID: suiteID);
}

extension PackagedGroupExt on Packaged<Group> {
  Packaged<GroupKey> get key => next((s) => s.key);
  Packaged<GroupKey>? get parentKey =>
      value.parentKey == null ? null : next((g) => g.parentKey!);
}

extension GroupExt on Group {
  GroupKey get key => GroupKey(
        groupID: id,
        suiteID: suiteID,
      );

  GroupKey? get parentKey =>
      parentID == null ? null : GroupKey(groupID: parentID!, suiteID: suiteID);

  SuiteKey get suiteKey => SuiteKey(suiteID: suiteID);
}

extension PackagedSuiteExt on Packaged<Suite> {
  Packaged<SuiteKey> get key => next((s) => s.key);
}

extension SuiteExt on Suite {
  SuiteKey get key => SuiteKey(
        suiteID: id,
      );
}

extension TestListExt on List<Test> {
  List<Test> sortedByStatus(AutoDisposeRef ref, String packagePath) {
    return sortedBy<num>((test) {
      return ref.watch($testStatus(Packaged(packagePath, test.key))).map(
            skip: (_) => 0,
            pass: (_) => 1,
            pending: (_) => 2,
            fail: (_) => 3,
          );
    });
  }
}
