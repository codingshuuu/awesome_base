import 'package:json_annotation/json_annotation.dart';

import 'converters_rx.dart';

///json解析类，自动生成
///flutter packages pub run build_runner build
const List<JsonConverter<dynamic, dynamic>> defaultConverters = [
  BoolNullableConverter(),
  IntConverter(),
  DoubleConverter(),
  StringConverter(),
];

const List<JsonConverter<dynamic, dynamic>> defaultRxConverters = [
  RxStringConverter(),
  RxBoolConverter(),
  RxIntConverter(),
];

/// 非 Optional 带默认值的 Converter
abstract class JsonNonnullConverter<T, S> implements JsonConverter<T, S> {
  final T defaultValue;
  final JsonConverter<T?, S> _converter;

  const JsonNonnullConverter(this.defaultValue, this._converter);

  @override
  T fromJson(S json) => _converter.fromJson(json) ?? defaultValue;

  @override
  S toJson(T object) => _converter.toJson(object);
}

/// bool 转换，true | num > 0 | '1' | 'true'
class BoolNullableConverter implements JsonConverter<bool?, Object?> {
  const BoolNullableConverter();

  @override
  bool? fromJson(Object? json) => json == null
      ? null
      : json is bool
          ? json
          : (json is num ? json > 0 : (json == '1' || json == 'true'));

  @override
  Object? toJson(bool? object) => object;
}

/// bool 转换，true | num > 0 | '1' | 'true'，默认值 false
class BoolConverter extends JsonNonnullConverter<bool, Object?> {
  const BoolConverter({bool defaultValue = false}) : super(defaultValue, const BoolNullableConverter());

  const BoolConverter.defaultTrue() : super(true, const BoolNullableConverter());

  const BoolConverter.defaultFalse() : super(false, const BoolNullableConverter());
}

/// int 转换，int | double | String，默认值 null
class IntNullableConverter implements JsonConverter<int?, Object?> {
  const IntNullableConverter();

  @override
  int? fromJson(Object? json) => json == null
      ? null
      : json is num
          ? json.toInt()
          : (json is String ? int.tryParse(json) : json as int?);

  @override
  Object? toJson(object) => object;
}

/// [int 转换，int | double | String]，默认值 0
class IntConverter extends JsonNonnullConverter<int, Object?> {
  const IntConverter({defaultValue = 0}) : super(defaultValue, const IntNullableConverter());
}

class DoubleNullableConverter implements JsonConverter<double?, Object?> {
  const DoubleNullableConverter();

  @override
  double? fromJson(Object? json) => json == null
      ? null
      : json is num
          ? json.toDouble()
          : (json is String ? double.tryParse(json) : json as double?);

  @override
  Object? toJson(object) => object;
}

/// double 转换，int ｜ double ｜ String，默认值 0.0
class DoubleConverter extends JsonNonnullConverter<double, Object?> {
  const DoubleConverter({double defaultValue = 0.0}) : super(defaultValue, const DoubleNullableConverter());
}

/// String 转换，任意类型 [toString]
class StringNullableConverter implements JsonConverter<String?, Object?> {
  const StringNullableConverter();

  @override
  String? fromJson(Object? json) => json?.toString();

  @override
  Object? toJson(object) => object;
}

/// String 转换，任意类型 [toString]，默认值 ''
class StringConverter extends JsonNonnullConverter<String, Object?> {
  const StringConverter({String defaultValue = ''}) : super(defaultValue, const StringNullableConverter());
}

/// Map<String, dynamic> 转换，非 Map类型默认值 {}
class MapConverter implements JsonConverter<Map<String, dynamic>, Object?> {
  const MapConverter();

  @override
  Map<String, dynamic> fromJson(Object? json) => json is Map<String, dynamic> ? json : {};

  @override
  Object? toJson(object) => object;
}

class ListConverter implements JsonConverter<List<dynamic>, Object?> {
  const ListConverter();

  @override
  List<dynamic> fromJson(Object? json) => json is List ? json : [];

  @override
  Object? toJson(object) => object;
}

/// String <-> List<String>，逗号隔开的 String 转 List
class JoinedListConverter implements JsonConverter<List<String>, Object?> {
  final String separator;

  const JoinedListConverter({this.separator = ','});

  @override
  List<String> fromJson(Object? json) => json == null
      ? []
      : json is String
          ? json.split(separator)
          : json is List
              ? json.cast<String>()
              : json as List<String>;

  @override
  String? toJson(object) => object.join(separator);
}

/// DateTime 转换，Unix 时间戳（秒）
class DateTimeNullableConverter implements JsonConverter<DateTime?, Object?> {
  const DateTimeNullableConverter();

  @override
  DateTime? fromJson(Object? json) => json is num ? DateTime.fromMillisecondsSinceEpoch(json * 1000 as int) : null;

  @override
  Object? toJson(object) => object?.millisecondsSinceEpoch ?? 0 ~/ 1000;
}

// class ObjectConverter<T> implements JsonConverter<Object, Object?> {
//   const ObjectConverter();
//   @override
//   Object fromJson(Object? json) {
//     // TODO: implement fromJson
//     throw UnimplementedError();
//   }

//   @override
//   Object? toJson(object) => object;
// }
