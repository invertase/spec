// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_protocol.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TestEventStart _$$TestEventStartFromJson(Map<String, dynamic> json) =>
    _$TestEventStart(
      protocolVersion: json['protocolVersion'] as String,
      pid: json['pid'] as int,
      time: json['time'] as int,
      runnerVersion: json['runnerVersion'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TestEventStartToJson(_$TestEventStart instance) =>
    <String, dynamic>{
      'protocolVersion': instance.protocolVersion,
      'pid': instance.pid,
      'time': instance.time,
      'runnerVersion': instance.runnerVersion,
      'type': instance.$type,
    };

_$TestEventDone _$$TestEventDoneFromJson(Map<String, dynamic> json) =>
    _$TestEventDone(
      success: json['success'] as bool?,
      time: json['time'] as int,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TestEventDoneToJson(_$TestEventDone instance) =>
    <String, dynamic>{
      'success': instance.success,
      'time': instance.time,
      'type': instance.$type,
    };

_$TestEventAllSuites _$$TestEventAllSuitesFromJson(Map<String, dynamic> json) =>
    _$TestEventAllSuites(
      count: json['count'] as int,
      time: json['time'] as int,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TestEventAllSuitesToJson(
        _$TestEventAllSuites instance) =>
    <String, dynamic>{
      'count': instance.count,
      'time': instance.time,
      'type': instance.$type,
    };

_$TestEventSuite _$$TestEventSuiteFromJson(Map<String, dynamic> json) =>
    _$TestEventSuite(
      Suite.fromJson(json['suite'] as Map<String, dynamic>),
      time: json['time'] as int,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TestEventSuiteToJson(_$TestEventSuite instance) =>
    <String, dynamic>{
      'suite': instance.suite,
      'time': instance.time,
      'type': instance.$type,
    };

_$TestEventGroup _$$TestEventGroupFromJson(Map<String, dynamic> json) =>
    _$TestEventGroup(
      Group.fromJson(json['group'] as Map<String, dynamic>),
      time: json['time'] as int,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TestEventGroupToJson(_$TestEventGroup instance) =>
    <String, dynamic>{
      'group': instance.group,
      'time': instance.time,
      'type': instance.$type,
    };

_$TestEventTestStart _$$TestEventTestStartFromJson(Map<String, dynamic> json) =>
    _$TestEventTestStart(
      Test.fromJson(json['test'] as Map<String, dynamic>),
      time: json['time'] as int,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TestEventTestStartToJson(
        _$TestEventTestStart instance) =>
    <String, dynamic>{
      'test': instance.test,
      'time': instance.time,
      'type': instance.$type,
    };

_$TestEventTestDone _$$TestEventTestDoneFromJson(Map<String, dynamic> json) =>
    _$TestEventTestDone(
      time: json['time'] as int,
      testID: json['testID'] as int,
      hidden: json['hidden'] as bool,
      skipped: json['skipped'] as bool,
      result: $enumDecode(_$TestDoneStatusEnumMap, json['result']),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TestEventTestDoneToJson(_$TestEventTestDone instance) =>
    <String, dynamic>{
      'time': instance.time,
      'testID': instance.testID,
      'hidden': instance.hidden,
      'skipped': instance.skipped,
      'result': _$TestDoneStatusEnumMap[instance.result],
      'type': instance.$type,
    };

const _$TestDoneStatusEnumMap = {
  TestDoneStatus.success: 'success',
  TestDoneStatus.failure: 'failure',
  TestDoneStatus.error: 'error',
};

_$TestEventMessage _$$TestEventMessageFromJson(Map<String, dynamic> json) =>
    _$TestEventMessage(
      time: json['time'] as int,
      testID: json['testID'] as int,
      messageType: json['messageType'] as String,
      message: json['message'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TestEventMessageToJson(_$TestEventMessage instance) =>
    <String, dynamic>{
      'time': instance.time,
      'testID': instance.testID,
      'messageType': instance.messageType,
      'message': instance.message,
      'type': instance.$type,
    };

_$TestEventTestError _$$TestEventTestErrorFromJson(Map<String, dynamic> json) =>
    _$TestEventTestError(
      time: json['time'] as int,
      testID: json['testID'] as int,
      error: json['error'] as String,
      stackTrace: json['stackTrace'] as String,
      isFailure: json['isFailure'] as bool,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TestEventTestErrorToJson(
        _$TestEventTestError instance) =>
    <String, dynamic>{
      'time': instance.time,
      'testID': instance.testID,
      'error': instance.error,
      'stackTrace': instance.stackTrace,
      'isFailure': instance.isFailure,
      'type': instance.$type,
    };

_$TestEventDebug _$$TestEventDebugFromJson(Map<String, dynamic> json) =>
    _$TestEventDebug(
      time: json['time'] as int,
      suiteID: json['suiteID'] as int,
      observatory: json['observatory'] as String?,
      remoteDebugger: json['remoteDebugger'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TestEventDebugToJson(_$TestEventDebug instance) =>
    <String, dynamic>{
      'time': instance.time,
      'suiteID': instance.suiteID,
      'observatory': instance.observatory,
      'remoteDebugger': instance.remoteDebugger,
      'type': instance.$type,
    };

_$TestEventUnknown _$$TestEventUnknownFromJson(Map<String, dynamic> json) =>
    _$TestEventUnknown(
      time: json['time'] as int,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TestEventUnknownToJson(_$TestEventUnknown instance) =>
    <String, dynamic>{
      'time': instance.time,
      'type': instance.$type,
    };

_$_Test _$$_TestFromJson(Map<String, dynamic> json) => _$_Test(
      id: json['id'] as int,
      name: json['name'] as String,
      suiteID: json['suiteID'] as int,
      groupIDs:
          (json['groupIDs'] as List<dynamic>).map((e) => e as int).toList(),
      line: json['line'] as int?,
      column: json['column'] as int?,
      url: json['url'] as String?,
      rootLine: json['root_line'] as int?,
      rootColumn: json['root_column'] as int?,
      rootUrl: json['root_url'] as String?,
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_TestToJson(_$_Test instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'suiteID': instance.suiteID,
      'groupIDs': instance.groupIDs,
      'line': instance.line,
      'column': instance.column,
      'url': instance.url,
      'root_line': instance.rootLine,
      'root_column': instance.rootColumn,
      'root_url': instance.rootUrl,
      'metadata': instance.metadata,
    };

_$_Suite _$$_SuiteFromJson(Map<String, dynamic> json) => _$_Suite(
      id: json['id'] as int,
      platform: json['platform'] as String,
      path: json['path'] as String?,
    );

Map<String, dynamic> _$$_SuiteToJson(_$_Suite instance) => <String, dynamic>{
      'id': instance.id,
      'platform': instance.platform,
      'path': instance.path,
    };

_$_Group _$$_GroupFromJson(Map<String, dynamic> json) => _$_Group(
      id: json['id'] as int,
      name: json['name'] as String,
      suiteID: json['suiteID'] as int,
      parentID: json['parentID'] as int?,
      testCount: json['testCount'] as int,
      line: json['line'] as int?,
      column: json['column'] as int?,
      url: json['url'] as String?,
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_GroupToJson(_$_Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'suiteID': instance.suiteID,
      'parentID': instance.parentID,
      'testCount': instance.testCount,
      'line': instance.line,
      'column': instance.column,
      'url': instance.url,
      'metadata': instance.metadata,
    };

_$_Metadata _$$_MetadataFromJson(Map<String, dynamic> json) => _$_Metadata(
      skip: json['skip'] as bool,
      skipReason: json['skipReason'] as String?,
    );

Map<String, dynamic> _$$_MetadataToJson(_$_Metadata instance) =>
    <String, dynamic>{
      'skip': instance.skip,
      'skipReason': instance.skipReason,
    };
