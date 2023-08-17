// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Book _$BookFromJson(Map<String, dynamic> json) {
  return _Book.fromJson(json);
}

/// @nodoc
mixin _$Book {
  String? get url => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get bookId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Pastry get pastry => throw _privateConstructorUsedError;
  @JsonKey(fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
  DateTime? get dateCreated => throw _privateConstructorUsedError;
  Recipe? get lastRecipe => throw _privateConstructorUsedError;
  int? get recipeCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookCopyWith<Book> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookCopyWith<$Res> {
  factory $BookCopyWith(Book value, $Res Function(Book) then) =
      _$BookCopyWithImpl<$Res, Book>;
  @useResult
  $Res call(
      {String? url,
      String title,
      String bookId,
      String? description,
      Pastry pastry,
      @JsonKey(
          fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
      DateTime? dateCreated,
      Recipe? lastRecipe,
      int? recipeCount});

  $RecipeCopyWith<$Res>? get lastRecipe;
}

/// @nodoc
class _$BookCopyWithImpl<$Res, $Val extends Book>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? title = null,
    Object? bookId = null,
    Object? description = freezed,
    Object? pastry = null,
    Object? dateCreated = freezed,
    Object? lastRecipe = freezed,
    Object? recipeCount = freezed,
  }) {
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      pastry: null == pastry
          ? _value.pastry
          : pastry // ignore: cast_nullable_to_non_nullable
              as Pastry,
      dateCreated: freezed == dateCreated
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastRecipe: freezed == lastRecipe
          ? _value.lastRecipe
          : lastRecipe // ignore: cast_nullable_to_non_nullable
              as Recipe?,
      recipeCount: freezed == recipeCount
          ? _value.recipeCount
          : recipeCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RecipeCopyWith<$Res>? get lastRecipe {
    if (_value.lastRecipe == null) {
      return null;
    }

    return $RecipeCopyWith<$Res>(_value.lastRecipe!, (value) {
      return _then(_value.copyWith(lastRecipe: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_BookCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$$_BookCopyWith(_$_Book value, $Res Function(_$_Book) then) =
      __$$_BookCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? url,
      String title,
      String bookId,
      String? description,
      Pastry pastry,
      @JsonKey(
          fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
      DateTime? dateCreated,
      Recipe? lastRecipe,
      int? recipeCount});

  @override
  $RecipeCopyWith<$Res>? get lastRecipe;
}

/// @nodoc
class __$$_BookCopyWithImpl<$Res> extends _$BookCopyWithImpl<$Res, _$_Book>
    implements _$$_BookCopyWith<$Res> {
  __$$_BookCopyWithImpl(_$_Book _value, $Res Function(_$_Book) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? title = null,
    Object? bookId = null,
    Object? description = freezed,
    Object? pastry = null,
    Object? dateCreated = freezed,
    Object? lastRecipe = freezed,
    Object? recipeCount = freezed,
  }) {
    return _then(_$_Book(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      pastry: null == pastry
          ? _value.pastry
          : pastry // ignore: cast_nullable_to_non_nullable
              as Pastry,
      dateCreated: freezed == dateCreated
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastRecipe: freezed == lastRecipe
          ? _value.lastRecipe
          : lastRecipe // ignore: cast_nullable_to_non_nullable
              as Recipe?,
      recipeCount: freezed == recipeCount
          ? _value.recipeCount
          : recipeCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Book extends _Book with DiagnosticableTreeMixin {
  const _$_Book(
      {required this.url,
      required this.title,
      required this.bookId,
      required this.description,
      required this.pastry,
      @JsonKey(
          fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
      required this.dateCreated,
      required this.lastRecipe,
      required this.recipeCount})
      : super._();

  factory _$_Book.fromJson(Map<String, dynamic> json) => _$$_BookFromJson(json);

  @override
  final String? url;
  @override
  final String title;
  @override
  final String bookId;
  @override
  final String? description;
  @override
  final Pastry pastry;
  @override
  @JsonKey(fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
  final DateTime? dateCreated;
  @override
  final Recipe? lastRecipe;
  @override
  final int? recipeCount;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Book(url: $url, title: $title, bookId: $bookId, description: $description, pastry: $pastry, dateCreated: $dateCreated, lastRecipe: $lastRecipe, recipeCount: $recipeCount)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Book'))
      ..add(DiagnosticsProperty('url', url))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('bookId', bookId))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('pastry', pastry))
      ..add(DiagnosticsProperty('dateCreated', dateCreated))
      ..add(DiagnosticsProperty('lastRecipe', lastRecipe))
      ..add(DiagnosticsProperty('recipeCount', recipeCount));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Book &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.pastry, pastry) || other.pastry == pastry) &&
            (identical(other.dateCreated, dateCreated) ||
                other.dateCreated == dateCreated) &&
            (identical(other.lastRecipe, lastRecipe) ||
                other.lastRecipe == lastRecipe) &&
            (identical(other.recipeCount, recipeCount) ||
                other.recipeCount == recipeCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, url, title, bookId, description,
      pastry, dateCreated, lastRecipe, recipeCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BookCopyWith<_$_Book> get copyWith =>
      __$$_BookCopyWithImpl<_$_Book>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BookToJson(
      this,
    );
  }
}

abstract class _Book extends Book {
  const factory _Book(
      {required final String? url,
      required final String title,
      required final String bookId,
      required final String? description,
      required final Pastry pastry,
      @JsonKey(
          fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
      required final DateTime? dateCreated,
      required final Recipe? lastRecipe,
      required final int? recipeCount}) = _$_Book;
  const _Book._() : super._();

  factory _Book.fromJson(Map<String, dynamic> json) = _$_Book.fromJson;

  @override
  String? get url;
  @override
  String get title;
  @override
  String get bookId;
  @override
  String? get description;
  @override
  Pastry get pastry;
  @override
  @JsonKey(fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
  DateTime? get dateCreated;
  @override
  Recipe? get lastRecipe;
  @override
  int? get recipeCount;
  @override
  @JsonKey(ignore: true)
  _$$_BookCopyWith<_$_Book> get copyWith => throw _privateConstructorUsedError;
}
