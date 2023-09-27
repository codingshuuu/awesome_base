import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

import 'converters.dart';

/// Rx<String> 转换，任意类型 [toString]
class RxStringConverter implements JsonConverter<Rx<String>, Object?> {
  const RxStringConverter();
  @override
  Rx<String> fromJson(Object? json) => Rx<String>(json?.toString() ?? '');

  @override
  Object? toJson(object) => object.value;
}

class RxBoolConverter implements JsonConverter<Rx<bool>, Object?> {
  const RxBoolConverter();
  @override
  Rx<bool> fromJson(Object? json) => Rx<bool>(const BoolConverter().fromJson(json));

  @override
  Object? toJson(object) => object.value;
}

class RxIntConverter implements JsonConverter<Rx<int>, Object?> {
  const RxIntConverter();
  @override
  Rx<int> fromJson(Object? json) => Rx<int>(const IntConverter().fromJson(json));

  @override
  Object? toJson(object) => object.value;
}
