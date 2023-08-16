// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return _Recipe.fromJson(json);
}

/// @nodoc
mixin _$Recipe {
  String get recipeId => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get coverImage => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  List<Ingredient>? get ingredients => throw _privateConstructorUsedError;
  List<Instruction>? get instructions => throw _privateConstructorUsedError;
  List<String> get bookIds => throw _privateConstructorUsedError;
  @JsonKey(fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecipeCopyWith<Recipe> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeCopyWith<$Res> {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) then) =
      _$RecipeCopyWithImpl<$Res, Recipe>;
  @useResult
  $Res call(
      {String recipeId,
      String? url,
      String? title,
      String? coverImage,
      String? description,
      List<String>? images,
      List<Ingredient>? ingredients,
      List<Instruction>? instructions,
      List<String> bookIds,
      @JsonKey(
          fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
      DateTime? createdAt});
}

/// @nodoc
class _$RecipeCopyWithImpl<$Res, $Val extends Recipe>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipeId = null,
    Object? url = freezed,
    Object? title = freezed,
    Object? coverImage = freezed,
    Object? description = freezed,
    Object? images = freezed,
    Object? ingredients = freezed,
    Object? instructions = freezed,
    Object? bookIds = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      recipeId: null == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      ingredients: freezed == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<Instruction>?,
      bookIds: null == bookIds
          ? _value.bookIds
          : bookIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RecipeCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$$_RecipeCopyWith(_$_Recipe value, $Res Function(_$_Recipe) then) =
      __$$_RecipeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String recipeId,
      String? url,
      String? title,
      String? coverImage,
      String? description,
      List<String>? images,
      List<Ingredient>? ingredients,
      List<Instruction>? instructions,
      List<String> bookIds,
      @JsonKey(
          fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
      DateTime? createdAt});
}

/// @nodoc
class __$$_RecipeCopyWithImpl<$Res>
    extends _$RecipeCopyWithImpl<$Res, _$_Recipe>
    implements _$$_RecipeCopyWith<$Res> {
  __$$_RecipeCopyWithImpl(_$_Recipe _value, $Res Function(_$_Recipe) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipeId = null,
    Object? url = freezed,
    Object? title = freezed,
    Object? coverImage = freezed,
    Object? description = freezed,
    Object? images = freezed,
    Object? ingredients = freezed,
    Object? instructions = freezed,
    Object? bookIds = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$_Recipe(
      recipeId: null == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      ingredients: freezed == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>?,
      instructions: freezed == instructions
          ? _value._instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<Instruction>?,
      bookIds: null == bookIds
          ? _value._bookIds
          : bookIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Recipe implements _Recipe {
  const _$_Recipe(
      {required this.recipeId,
      required this.url,
      required this.title,
      required this.coverImage,
      required this.description,
      required final List<String>? images,
      required final List<Ingredient>? ingredients,
      required final List<Instruction>? instructions,
      required final List<String> bookIds,
      @JsonKey(
          fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
      required this.createdAt})
      : _images = images,
        _ingredients = ingredients,
        _instructions = instructions,
        _bookIds = bookIds;

  factory _$_Recipe.fromJson(Map<String, dynamic> json) =>
      _$$_RecipeFromJson(json);

  @override
  final String recipeId;
  @override
  final String? url;
  @override
  final String? title;
  @override
  final String? coverImage;
  @override
  final String? description;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Ingredient>? _ingredients;
  @override
  List<Ingredient>? get ingredients {
    final value = _ingredients;
    if (value == null) return null;
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Instruction>? _instructions;
  @override
  List<Instruction>? get instructions {
    final value = _instructions;
    if (value == null) return null;
    if (_instructions is EqualUnmodifiableListView) return _instructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String> _bookIds;
  @override
  List<String> get bookIds {
    if (_bookIds is EqualUnmodifiableListView) return _bookIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookIds);
  }

  @override
  @JsonKey(fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Recipe(recipeId: $recipeId, url: $url, title: $title, coverImage: $coverImage, description: $description, images: $images, ingredients: $ingredients, instructions: $instructions, bookIds: $bookIds, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Recipe &&
            (identical(other.recipeId, recipeId) ||
                other.recipeId == recipeId) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality()
                .equals(other._instructions, _instructions) &&
            const DeepCollectionEquality().equals(other._bookIds, _bookIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      recipeId,
      url,
      title,
      coverImage,
      description,
      const DeepCollectionEquality().hash(_images),
      const DeepCollectionEquality().hash(_ingredients),
      const DeepCollectionEquality().hash(_instructions),
      const DeepCollectionEquality().hash(_bookIds),
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RecipeCopyWith<_$_Recipe> get copyWith =>
      __$$_RecipeCopyWithImpl<_$_Recipe>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RecipeToJson(
      this,
    );
  }
}

abstract class _Recipe implements Recipe {
  const factory _Recipe(
      {required final String recipeId,
      required final String? url,
      required final String? title,
      required final String? coverImage,
      required final String? description,
      required final List<String>? images,
      required final List<Ingredient>? ingredients,
      required final List<Instruction>? instructions,
      required final List<String> bookIds,
      @JsonKey(
          fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
      required final DateTime? createdAt}) = _$_Recipe;

  factory _Recipe.fromJson(Map<String, dynamic> json) = _$_Recipe.fromJson;

  @override
  String get recipeId;
  @override
  String? get url;
  @override
  String? get title;
  @override
  String? get coverImage;
  @override
  String? get description;
  @override
  List<String>? get images;
  @override
  List<Ingredient>? get ingredients;
  @override
  List<Instruction>? get instructions;
  @override
  List<String> get bookIds;
  @override
  @JsonKey(fromJson: getDateTimeFromTimestamp, toJson: getTimestampFromDateTime)
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_RecipeCopyWith<_$_Recipe> get copyWith =>
      throw _privateConstructorUsedError;
}
