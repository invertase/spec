import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:riverpod/riverpod.dart';

import 'collection.dart';
import 'dart_test.dart';
import 'dart_test_utils.dart';
import 'provider_utils.dart';

final $group = Provider.family
    .autoDispose<AsyncValue<Group>, Packaged<GroupKey>>((ref, groupKey) {
  return ref
      .watch($events)
      .events
      .where((e) => e.packagePath == groupKey.packagePath)
      .map((e) => e.value)
      .whereType<TestEventGroup>()
      .where((e) => e.group.key == groupKey.value)
      .map((e) => e.group)
      .firstDataOrLoading;
}, dependencies: [$events]);

final AutoDisposeProviderFamily<AsyncValue<int>, Packaged<GroupKey>>
    $groupDepth = Provider.autoDispose
        .family<AsyncValue<int>, Packaged<GroupKey>>((ref, groupKey) {
  return merge((unwrap) {
    final group = unwrap(ref.watch($group(groupKey)));
    final parentGroupKey = group.parentID != null
        ? Packaged(groupKey.packagePath, group.parentKey!)
        : null;

    final parent = parentGroupKey != null
        ? unwrap(ref.watch($group(parentGroupKey)))
        : null;

    if (parent == null || parent.parentID == null) {
      return 0;
    }

    return unwrap(ref.watch($groupDepth(parentGroupKey!))) + 1;
  });
}, dependencies: [$group]);

final $groupName = Provider.autoDispose
    .family<AsyncValue<String>, Packaged<GroupKey>>((ref, groupKey) {
  return merge((unwrap) {
    final group = unwrap(ref.watch($group(groupKey)));
    final parentGroupKey = group.parentID != null
        ? Packaged(groupKey.packagePath, group.parentKey!)
        : null;
    final parentGroup = parentGroupKey != null
        ? unwrap(ref.watch($group(parentGroupKey)))
        : null;

    if (parentGroup == null || parentGroup.parentID == null) {
      return group.name;
    }

    // group names are the concatenation of their name plus their parent's name
    // and a whitespace. So to determine the true group name, we're removing those
    return group.name.substring(parentGroup.name.length + 1);
  });
}, dependencies: [$group]);

/// The virtual top-most group added by the test package.
final $scaffoldGroup = Provider.family
    .autoDispose<AsyncValue<Group>, Packaged<SuiteKey>>((ref, suiteKey) {
  return ref
      .watch($events)
      .events
      .where((e) => e.packagePath == suiteKey.packagePath)
      .map((e) => e.value)
      .whereType<TestEventGroup>()
      .where(
        (e) => e.group.parentID == null && e.group.suiteKey == suiteKey.value,
      )
      .map((e) => e.group)
      .firstDataOrLoading;
}, dependencies: [$events]);

/// User-defined groups at the root of a suite (excluding [$scaffoldGroup])
final $rootGroupsForSuite = Provider.family
    .autoDispose<List<Group>, Packaged<SuiteKey>>((ref, suiteKey) {
  final scaffoldGroup = ref.watch($scaffoldGroup(suiteKey));
  return scaffoldGroup.when(
    error: (err, stack) {
      throw StateError('??');
      // throw Error.throwWithStackTrace(err, stack ?? StackTrace.current);
    },
    loading: () => [],
    data: (scaffoldGroup) {
      return ref
          .watch($events)
          .events
          .where((e) => e.packagePath == suiteKey.packagePath)
          .map((e) => e.value)
          .whereType<TestEventGroup>()
          .where((e) => e.group.parentKey == scaffoldGroup.key)
          .map((e) => e.group)
          .toList();
    },
  );
}, dependencies: [$scaffoldGroup, $events]);

final $childrenGroupsForGroup = Provider.family
    .autoDispose<List<Group>, Packaged<GroupKey>>((ref, groupKey) {
  return ref
      .watch($events)
      .events
      .where((e) => e.packagePath == groupKey.packagePath)
      .map((e) => e.value)
      .whereType<TestEventGroup>()
      .where((e) => e.group.parentKey == groupKey.value)
      .map((e) => e.group)
      .toList();
}, dependencies: [$events]);
