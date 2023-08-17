// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'baker_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BakerMessage _$BakerMessageFromJson(Map<String, dynamic> json) {
  return _BakerMessage.fromJson(json);
}

/// @nodoc
mixin _$BakerMessage {
  String? get prompt => throw _privateConstructorUsedError;
  String? get response => throw _privateConstructorUsedError;
  @JsonKey(fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BakerMessageCopyWith<BakerMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BakerMessageCopyWith<$Res> {
  factory $BakerMessageCopyWith(
          BakerMessage value, $Res Function(BakerMessage) then) =
      _$BakerMessageCopyWithImpl<$Res, BakerMessage>;
  @useResult
  $Res call(
      {String? prompt,
      String? response,
      @JsonKey(
          fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
      DateTime? createdAt});
}

/// @nodoc
class _$BakerMessageCopyWithImpl<$Res, $Val extends BakerMessage>
    implements $BakerMessageCopyWith<$Res> {
  _$BakerMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prompt = freezed,
    Object? response = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      prompt: freezed == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BakerMessageCopyWith<$Res>
    implements $BakerMessageCopyWith<$Res> {
  factory _$$_BakerMessageCopyWith(
          _$_BakerMessage value, $Res Function(_$_BakerMessage) then) =
      __$$_BakerMessageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? prompt,
      String? response,
      @JsonKey(
          fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
      DateTime? createdAt});
}

/// @nodoc
class __$$_BakerMessageCopyWithImpl<$Res>
    extends _$BakerMessageCopyWithImpl<$Res, _$_BakerMessage>
    implements _$$_BakerMessageCopyWith<$Res> {
  __$$_BakerMessageCopyWithImpl(
      _$_BakerMessage _value, $Res Function(_$_BakerMessage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prompt = freezed,
    Object? response = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$_BakerMessage(
      prompt: freezed == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BakerMessage extends _BakerMessage {
  const _$_BakerMessage(
      {required this.prompt,
      required this.response,
      @JsonKey(
          fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
      required this.createdAt})
      : super._();

  factory _$_BakerMessage.fromJson(Map<String, dynamic> json) =>
      _$$_BakerMessageFromJson(json);

  @override
  final String? prompt;
  @override
  final String? response;
  @override
  @JsonKey(fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'BakerMessage(prompt: $prompt, response: $response, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BakerMessage &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, prompt, response, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BakerMessageCopyWith<_$_BakerMessage> get copyWith =>
      __$$_BakerMessageCopyWithImpl<_$_BakerMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BakerMessageToJson(
      this,
    );
  }
}

abstract class _BakerMessage extends BakerMessage {
  const factory _BakerMessage(
      {required final String? prompt,
      required final String? response,
      @JsonKey(
          fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
      required final DateTime? createdAt}) = _$_BakerMessage;
  const _BakerMessage._() : super._();

  factory _BakerMessage.fromJson(Map<String, dynamic> json) =
      _$_BakerMessage.fromJson;

  @override
  String? get prompt;
  @override
  String? get response;
  @override
  @JsonKey(fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_BakerMessageCopyWith<_$_BakerMessage> get copyWith =>
      throw _privateConstructorUsedError;
}
