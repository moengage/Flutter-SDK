// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:moengage_flutter/moengage_flutter.dart'
    show keyAccountMeta, keyAppId, keyData;

import '../../moengage_<featureName>_platform_interface.dart';

// Deserializer for each Future result method — one function per return type:
<ResultModel> deSerialize<ResultModel>(String payload) {
  final dataPayload = jsonDecode(payload)[keyData];
  return <ResultModel>.fromJson(dataPayload as Map<String, dynamic>);
}

// Simple scalar example (bool/int/String):
bool deSerialize<BoolField>(String payload) {
  final Map<String, dynamic> dataPayload =
      jsonDecode(payload)[keyData] as Map<String, dynamic>;
  return (dataPayload[key<BoolField>] ?? false) as bool;
}

// Payload builders for hybridToNative methods that need extra data beyond accountMeta:
Map<String, dynamic> get<MethodName>Payload(<ParamType> param, String appId) {
  return {
    keyAccountMeta: {keyAppId: appId},
    keyData: {key<Param>: param}
  };
}

// Enum ↔ string converters — only if event/response payloads contain enum fields:
<EnumName> <enumName>FromString(String? value) {
  switch (value) {
    case argument<ValueOne>:
      return <EnumName>.<valueOne>;
    case argument<ValueTwo>:
      return <EnumName>.<valueTwo>;
    default:
      throw UnimplementedError('<EnumName> value not supported: $value');
  }
}

String <enumName>ToString(<EnumName> value) {
  switch (value) {
    case <EnumName>.<valueOne>:
      return argument<ValueOne>;
    case <EnumName>.<valueTwo>:
      return argument<ValueTwo>;
  }
}
