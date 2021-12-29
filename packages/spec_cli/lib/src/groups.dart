import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:spec_cli/src/rendering.dart';

import 'dart_test.dart';
import 'dart_test_utils.dart';
import 'provider_utils.dart';

final $group = FutureProvider.family<Group, GroupKey>((ref, groupKey) async {
  final groupEvent = await ref
      .watch($result) //
      .groups()
      .firstWhere((e) => e.group.key == groupKey);

  return groupEvent.group;
}, dependencies: [$result]);

final AutoDisposeProviderFamily<AsyncValue<int>, GroupKey> $groupDepth =
    Provider.autoDispose.family<AsyncValue<int>, GroupKey>((ref, groupKey) {
  return merge((unwrap) {
    final group = unwrap(ref.watch($group(groupKey)));
    final parent = group.parentID != null
        ? unwrap(ref.watch($group(group.parentKey!)))
        : null;

    if (parent == null || parent.parentID == null) {
      return 0;
    }

    return unwrap(ref.watch($groupDepth(group.parentKey!))) + 1;
  });
}, dependencies: [$group]);

final $groupName =
    Provider.autoDispose.family<AsyncValue<String>, GroupKey>((ref, groupKey) {
  return merge((unwrap) {
    final group = unwrap(ref.watch($group(groupKey)));
    final parentGroup = group.parentKey == null
        ? null
        : unwrap(ref.watch($group(group.parentKey!)));

    if (parentGroup == null || parentGroup.parentID == null) {
      return group.name;
    }

    // group names are the concatenation of their name plus their parent's name
    // and a whitespace. So to determine the true group name, we're removing those
    return group.name.substring(parentGroup.name.length + 1);
  });
}, dependencies: [$group]);

/// The virtual top-most group added by the test package.
final $scaffoldGroup = FutureProvider.family<Group, SuiteKey>((ref, suiteKey) {
  return ref
      .watch($result)
      .groups()
      .firstWhere(
          (e) => e.group.parentID == null && e.group.suiteKey == suiteKey)
      .then((e) => e.group);
}, dependencies: [$result]);

/// User-defined groups at the root of a suite (excluding [$scaffoldGroup])
final $rootGroupsForSuite =
    Provider.family<List<Group>, SuiteKey>((ref, suiteKey) {
  ref.watch($scaffoldGroup(suiteKey).future).then((scaffoldGroup) {
    final rootGroups = ref
        .watch($result)
        .groups()
        .where((e) => e.group.parentKey == scaffoldGroup.key)
        .map((e) => e.group)
        .combined();

    final sub = rootGroups.listen((rootGroups) => ref.state = rootGroups);
    ref.onDispose(sub.cancel);
  });

  return [];
}, dependencies: [$scaffoldGroup, $result]);

final $childrenGroupsForGroup =
    Provider.family<List<Group>, GroupKey>((ref, groupKey) {
  final children = ref
      .watch($result)
      .groups()
      .where((e) => e.group.parentKey == groupKey)
      .map((e) => e.group)
      .combined();

  final sub = children.listen((children) => ref.state = children);
  ref.onDispose(sub.cancel);

  return [];
}, dependencies: [$result]);
