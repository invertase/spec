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

extension GroupExt on Group {
  GroupKey get key => GroupKey(
        groupID: id,
        suiteID: suiteID,
      );

  GroupKey? get parentKey =>
      parentID == null ? null : GroupKey(groupID: parentID!, suiteID: suiteID);

  SuiteKey get suiteKey => SuiteKey(suiteID: suiteID);
}

extension SuiteExt on Suite {
  SuiteKey get key => SuiteKey(
        suiteID: id,
      );
}

extension TestListExt on List<Test> {
  List<Test> sortedByStatus(Ref ref) {
    return sortedBy<num>((test) {
      return ref.watch($testStatus(test.key)).map(
            skip: (_) => 0,
            pass: (_) => 1,
            pending: (_) => 2,
            fail: (_) => 3,
          );
    });
  }
}
